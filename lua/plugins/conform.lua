return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = 'n',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    -- Disable format-on-save for specific filetypes
    format_on_save = function(bufnr)
      local disabled = { c = true, cpp = true }
      if disabled[vim.bo[bufnr].filetype] then
        return nil
      end
      return {
        timeout_ms = 1000,
        lsp_format = 'fallback',
      }
    end,
    -- Formatters per filetype
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      html = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      dockerfile = { 'prettier' },
      go = { 'gofumpt', 'goimports' },
    },
    -- Formatter config
    formatters = {
      stylua = {
        prepend_args = {
          '--column-width',
          '160',
          '--line-endings',
          'Unix',
          '--indent-type',
          'Spaces',
          '--indent-width',
          '2',
          '--quote-style',
          'AutoPreferSingle',
          '--call-parentheses',
          'None',
        },
      },
    },
  },
}
