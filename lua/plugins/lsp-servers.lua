return {
  'mason-org/mason-lspconfig.nvim',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'neovim/nvim-lspconfig',
    'saghen/blink.cmp',
  },

  opts = {},

  config = function()
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
            completion = {
              callSnippet = 'Replace',
            },
            format = {
              enable = false,
            },
          },
        },
      },
      pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              typeCheckingMode = 'standard',
            },
          },
        },
      },
      ruff_lsp = {
        on_attach = function(client, _)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      },
      gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              nilness = true,
              unusedwrite = true,
              unusedvariable = true,
            },
            usePlaceholders = true,
            staticcheck = true,
            gofumpt = true,
          },
        },
      },
      vtsls = {
        settings = {
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
          },
          typescript = {
            inlayHints = {
              parameterNames = { enabled = 'literals' },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            keyOrdering = false, -- prevents reordering keys during edits
            schemaStore = { enable = true },
          },
        },
      },
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      },

      marksman = {},

      dockerls = {},
    }

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
