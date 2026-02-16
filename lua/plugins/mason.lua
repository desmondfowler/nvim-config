return {
  'mason-org/mason.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = {
    'Mason',
    'MasonInstall',
    'MasonUninstall',
    'MasonUninstallAll',
    'MasonLog',
    'MasonUpdate',
  },
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
        'gopls',
        'vtsls',
        'yaml-language-server',
        'json-lsp',
        'marksman',
        'dockerfile-language-server',
      },
    }
  end,
}
