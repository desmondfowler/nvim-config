return {
  'folke/todo-comments.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader>st',
      '<cmd>TodoTelescope<cr>',
      desc = '[S]earch [T]ODOs',
    },
  },
  opts = {
    signs = false,
    highlight = {
      multiline = false,
    },
  },
}
