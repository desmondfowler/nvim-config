return {
  'linux-cultist/venv-selector.nvim',
  cmd = { 'VenvSelect', 'VenvSelectCached' },
  opts = {},
  keys = {
    { '<leader>vs', '<cmd>VenvSelect<CR>', desc = 'Select VirtualEnv' },
  },
}
