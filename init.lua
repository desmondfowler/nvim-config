-- init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Options
require 'config.options'
-- Keymaps
require 'config.keymaps'
-- Autocommands
require 'config.autocmds'
-- Bootstrap lazy
require 'config.lazy'
