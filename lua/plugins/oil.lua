return {
  'stevearc/oil.nvim',
  cmd = 'Oil',
  config = function()
    require('oil').setup {
      columns = {
        'icon',
        'permissions',
        'size',
        'mtime',
      },
      delete_to_trash = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
      },
      float = {
        padding = 2,
        max_width = 60,
        max_height = 20,
        border = 'rounded',
        win_options = {
          winblend = 0,
        },
      },
    }
  end,
}
