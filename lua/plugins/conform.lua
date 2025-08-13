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
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'black' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      json = { 'prettier' },
      sql = { 'sql_formatter' },
      pls = { 'sql_formatter' },
    },
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
      sql_formatter = {

        command = 'sql-formatter',
        args = { '-l', 'plsql' },
      },
    },
  },
}
