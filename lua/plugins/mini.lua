return {
  'echasnovski/mini.nvim',
  config = function()
    require('mini.ai').setup { n_lines = 500 }

    require('mini.surround').setup()

    local statusline = require 'mini.statusline'
    statusline.setup {
      use_icons = vim.g.have_nerd_font,
      content = {
        active = function()
          local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
          local git = statusline.section_git { trunc_width = 75 }
          local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
          local filename = statusline.section_filename { trunc_width = 140 }
          local location = statusline.section_location()
          return statusline.combine_groups {
            { hl = mode_hl, strings = { mode } },
            { strings = { git, diagnostics } },
            '%<', -- Left truncate
            { strings = { filename } },
            '%=', -- Right align
            { strings = { location } },
          }
        end,
      },
    }
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end
  end,
}
