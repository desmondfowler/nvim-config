return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
  config = function()
    require('oil').setup {
      columns = {
        'icon',
        'permissions',
        'size',
        'mtime',
      },
      delete_to_trash = true,
    }
  end,
}
