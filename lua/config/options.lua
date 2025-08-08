-- options.lua
vim.g.python3_host_prog = '/home/desmond/venv/bin/python'
vim.g.have_nerd_font = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.showmode = false
vim.o.mouse = 'a'
vim.o.wrap = false
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
-- vim.o.list = true
-- vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 5
vim.o.confirm = true
vim.o.termguicolors = true
vim.o.timeoutlen = 500
vim.o.updatetime = 200

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.autoindent = true
vim.o.smartindent = false

-- Sync clipboard
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
