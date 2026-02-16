# Neovim Configuration

A Lazy-based Neovim configuration with LSP, Treesitter, Telescope, DAP, formatting, and Git integration.

## Requirements

This setup is currently supported by the installer on:

- Fedora (`dnf`)
- Debian/Ubuntu (`apt`)

`requirements.sh` expects:

- normal user (not root)
- `sudo`
- network access

## Install

You can run the installer directly from this repo:

```bash
cd ~/.config/nvim
./requirements.sh
```

Or bootstrap from GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/desmondfowler/nvim-config/master/requirements.sh | bash
```

## Installer Behavior

`requirements.sh` installs system dependencies, Rust/Cargo (if needed), Bob + Neovim nightly, Node/npm + prettier, Python venv tooling, tree-sitter CLI, and syncs plugins.

### Flags

```bash
./requirements.sh --help
```

- `--existing` / `-e`: keep and use existing `~/.config/nvim` (skip backup/remove/clone)
- `--force` / `-f`: allow replacing `~/.config/nvim` even if it is a dirty git repo

### Existing Config Prompt

If `~/.config/nvim` already exists (and `--existing` is not used), the script prompts:

- `y`: backup then replace
- `n`: replace without backup
- `e`: keep existing config (skip clone/replace)

### Dirty Git Safeguard

If `~/.config/nvim` is a git repo with uncommitted/untracked changes, replacement is blocked unless `--force` is passed.

## Plugins

Current plugin spec files:

```bash
lua/plugins/
├── blink.lua
├── colorscheme.lua
├── conform.lua
├── dap.lua
├── gitsigns.lua
├── gotest.lua
├── lsp-servers.lua
├── lsp.lua
├── mason.lua
├── mini.lua
├── oil.lua
├── py-venv-activate.lua
├── schemastore.lua
├── telescope.lua
├── todo-comments.lua
├── treesitter.lua
└── whichkey.lua
```

## Lazy-Loading Notes

- `:Mason` is available without opening a file (command-triggered load).
- DAP is command/key-triggered (`<F5>`, `<F10>`, `<F11>`, `<F12>`, `<leader>db`, `<leader>dc`, `<leader>du`).
- LSP server setup is lazy on buffer read/new file.

## Update Workflow

```bash
cd ~/.config/nvim
git pull origin master
bob update nightly
nvim --headless -c 'Lazy sync' -c 'qa'
```

## Verification

After install/update:

- `:checkhealth`
- `:Mason`
- `:Lazy profile`
- `:LspInfo` in a project buffer
