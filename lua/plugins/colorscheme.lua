return {
  -- 'morhetz/gruvbox',
  -- lazy = false,
  -- priority = 1000,
  -- config = function()
  --   vim.g.gruvbox_contrast_dark = 'medium'
  --   vim.g.gruvbox_transparent_bg = 1
  --   vim.cmd.colorscheme 'gruvbox'
  -- end,

  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'kanagawa'
  end,
}
