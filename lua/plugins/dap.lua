return {
  'mfussenegger/nvim-dap',
  event = 'VeryLazy',
  dependencies = {
    'jay-babu/mason-nvim-dap.nvim',
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
  },

  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      ensure_installed = {
        'js-debug-adapter',
        'debugpy',
        'delve',
      },
      automatic_setup = true,
    }
    dap.adapters.python = {
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python',
      args = { '-m', 'debugpy.adapter' },
    }
    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        console = 'integratedTerminal',
      },
    }

    dap.adapters.go = function(callback, _)
      callback {
        type = 'server',
        host = '127.0.0.1',
        port = 38697,
      }
    end

    dap.configurations.go = {
      {
        type = 'go',
        name = 'Debug',
        request = 'launch',
        program = '${file}',
      },
      {
        type = 'go',
        name = 'Debug test',
        request = 'launch',
        mode = 'test',
        program = '${file}',
      },
      {
        type = 'go',
        name = 'Debug package tests',
        request = 'launch',
        mode = 'test',
        program = './...',
      },
    }

    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    local map = vim.keymap.set

    map('n', '<F5>', dap.continue, { desc = 'DAP Continue' })
    map('n', '<F10>', dap.step_over, { desc = 'DAP Step Over' })
    map('n', '<F11>', dap.step_into, { desc = 'DAP Step Into' })
    map('n', '<F12>', dap.step_out, { desc = 'DAP Step Out' })
    map('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
    map('n', '<leader>dc', dap.run_to_cursor, { desc = 'Run to Cursor' })
    map('n', '<leader>du', dapui.toggle, { desc = 'Toggle DAP UI' })
  end,
}
