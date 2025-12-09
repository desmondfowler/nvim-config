-- lua/plugins/colorscheme.lua
return {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('gruvbox').setup {
      contrast = 'hard',
      transparent_mode = false,
      overrides = {
        InlayHint = { fg = '#928374', bg = 'none', italic = true },
        DiagnosticUnderlineError = { undercurl = true, sp = '#fb4934' },
        DiagnosticUnderlineWarn = { undercurl = true, sp = '#fabd2f' },
        DiagnosticUnderlineInfo = { undercurl = true, sp = '#83a598' },
        DiagnosticUnderlineHint = { undercurl = true, sp = '#8ec07c' },
      },
    }
    vim.cmd.colorscheme 'gruvbox'
  end,
}
