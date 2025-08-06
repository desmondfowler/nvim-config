# Neovim Configuration

A Neovim setup with Lazy, LSP, Treesitter, etc. Uses the nightly Neovim version managed by Bob.

## Installation

Ensure you have `sudo` and `curl` on your system, then run the following script:

```bash
curl -fsSL https://raw.githubusercontent.com/desmondfowler/nvim-config/master/requirements.sh | bash
```

## Dependencies

All installed by the `requirements.sh` script. 

## Plugins

As of right now, the plugins contained are as follows:

```bash
lua/plugins/
├── autopairs.lua
├── blink.lua
├── colorscheme.lua
├── conform.lua
├── gitsigns.lua
├── lazydev.lua
├── lspconfig.lua
├── mini.lua
├── oil.lua
├── telescope.lua
├── todo_comments.lua
├── treesitter.lua
└── whichkey.lua

1 directory, 13 files
```

NOTE: These are not the actual github repo names, they are just what I called my lua files for Lazy. They mostly match, but for example, `colorscheme.lua` is just a basic lua file that you can change the colorscheme in to have it use a different scheme.

## Updating

Run the following:

```bash
cd ~/.config/nvim
git pull origin master
bob update nightly
nvim --headless -c 'Lazy sync' -c 'qa'
```
