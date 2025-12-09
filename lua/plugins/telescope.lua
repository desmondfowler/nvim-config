return {
  'nvim-telescope/telescope.nvim',

  -- Lazy-load when :Telescope is called OR a keymap calls a telescope function
  cmd = 'Telescope',

  -- Lazy keymaps: Telescope loads only when one of these keys is pressed
  keys = {
    {
      '<leader>sh',
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      function()
        require('telescope.builtin').keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>sf',
      function()
        require('telescope.builtin').find_files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>ss',
      function()
        require('telescope.builtin').builtin()
      end,
      desc = '[S]earch [S]elect Telescope',
    },
    {
      '<leader>sw',
      function()
        require('telescope.builtin').grep_string()
      end,
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>sg',
      function()
        require('telescope.builtin').live_grep()
      end,
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sd',
      function()
        require('telescope.builtin').diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        require('telescope.builtin').resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>s.',
      function()
        require('telescope.builtin').oldfiles()
      end,
      desc = '[S]earch Recent Files',
    },
    {
      '<leader><leader>',
      function()
        require('telescope.builtin').buffers()
      end,
      desc = '[ ] Find buffers',
    },

    -- Buffer fuzzy search
    {
      '<leader>/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end,
      desc = '[/] Fuzzy search buffer',
    },

    -- Live grep open files
    {
      '<leader>s/',
      function()
        require('telescope.builtin').live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end,
      desc = '[S]earch [/] in open files',
    },

    -- Search Neovim config files
    {
      '<leader>sn',
      function()
        require('telescope.builtin').find_files {
          cwd = vim.fn.stdpath 'config',
        }
      end,
      desc = '[S]earch [N]eovim config',
    },
  },

  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-telescope/telescope-ui-select.nvim',
  },

  config = function()
    local telescope = require 'telescope'

    telescope.setup {
      defaults = {
        layout_strategy = 'flex',
        sorting_strategy = 'ascending',
        path_display = { 'truncate' },
        layout_config = {
          prompt_position = 'top',
        },
        file_ignore_patterns = {
          'node_modules',
          '%.git/',
          'dist/',
          'build/',
          '%.cache',
          '%.next/',
        },
      },

      extensions = {
        fzf = {
          fuzzy = true,
          override_file_sorter = true,
          override_generic_sorter = true,
          case_mode = 'smart_case',
        },
        ['ui-select'] = require('telescope.themes').get_dropdown(),
      },
    }

    -- Load extensions safely
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
  end,
}
