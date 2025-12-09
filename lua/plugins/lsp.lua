return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },

  config = function()
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      virtual_text = {
        source = 'if_many',
        spacing = 2,
      },
    }

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
        end

        map('grn', vim.lsp.buf.rename, 'Rename')
        map('gra', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
        map('grr', require('telescope.builtin').lsp_references, 'References')
        map('gri', require('telescope.builtin').lsp_implementations, 'Implementations')
        map('grd', require('telescope.builtin').lsp_definitions, 'Definitions')
        map('grt', require('telescope.builtin').lsp_type_definitions, 'Type definitions')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities and client.server_capabilities.inlayHintProvider then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, 'Toggle inlay hints')
        end
      end,
    })
  end,
}
