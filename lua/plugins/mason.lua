return {
  'mason-org/mason.nvim',
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  opts = {
    ui = {
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
      },
    },
  },
  config = function(_, opts)
    require('mason').setup(opts)

    require('mason-tool-installer').setup {
      ensure_installed = {
        -- Formatters / linters
        'stylua',
        'prettier',
        'ruff',
        'debugpy',
        'goimports',
        'gofumpt',
        'golangci-lint',
        'delve',

        -- LSP servers
        'lua-language-server',
        'pyright',
        'ruff-lsp',
        'gopls',

        'vtsls',
      },
    }
  end,
}
