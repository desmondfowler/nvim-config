return {
  'mfussenegger/nvim-dap',
  cmd = {
    'DapContinue',
    'DapToggleBreakpoint',
    'DapStepOver',
    'DapStepInto',
    'DapStepOut',
    'DapTerminate',
    'DapUIOpen',
    'DapUIClose',
    'DapUIToggle',
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'DAP Continue',
    },
    {
      '<F10>',
      function()
        require('dap').step_over()
      end,
      desc = 'DAP Step Over',
    },
    {
      '<F11>',
      function()
        require('dap').step_into()
      end,
      desc = 'DAP Step Into',
    },
    {
      '<F12>',
      function()
        require('dap').step_out()
      end,
      desc = 'DAP Step Out',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Toggle Breakpoint',
    },
    {
      '<leader>dc',
      function()
        require('dap').run_to_cursor()
      end,
      desc = 'Run to Cursor',
    },
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = 'Toggle DAP UI',
    },
  },
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
  end,
}
