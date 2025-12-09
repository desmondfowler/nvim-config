return {
  'nvim-mini/mini.nvim',
  event = 'VeryLazy',
  config = function()
    require('mini.ai').setup { n_lines = 500 }
    require('mini.surround').setup()
    require('mini.pairs').setup()
    require('mini.icons').setup()
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
          local enc = statusline.section_fileinfo { trunc_width = 120 }
          return statusline.combine_groups {
            { hl = mode_hl, strings = { mode } },
            { strings = { git, diagnostics } },
            '%<', -- Left truncate
            { strings = { filename } },
            '%=', -- Right align
            { strings = { enc } },
            { strings = { location } },
          }
        end,
      },
    }
    statusline.section_location = function()
      return '%2l:%-2v'
    end
  end,
}
