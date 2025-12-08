return {
  'ray-x/go.nvim',
  dependencies = { 'ray-x/guihua.lua', 'neovim/nvim-lspconfig', 'nvim-treesitter/nvim-treesitter' },
  opts = function()
    require('go').setup(opts)
    local format_sync_grp = vim.api.nvim_create_augroup('GoFormat', {})
    return {}
  end,
  event = { 'CmdlineEnter' },
  ft = { 'go', 'gomod' },
  build = ':lua require("go.install").update_all_sync()',
}
