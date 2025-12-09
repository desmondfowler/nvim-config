return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/neotest-go',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    {
      '<leader>tn',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run nearest test',
    },
    {
      '<leader>tf',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = 'Run file tests',
    },
    {
      '<leader>ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle test summary',
    },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-go' {
          experimental = { test_table = true },
        },
      },
    }
  end,
}
