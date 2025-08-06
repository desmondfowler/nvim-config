#!/bin/bash

set -e # Exit on error

# Define variables
NVIM_CONFIG_DIR="$HOME/.config/nvim"
REPO_URL="https://github.com/desmondfowler/nvim-config.git"
BACKUP_DIR="$HOME/.config/nvim-backup-$(date +%Y%m%d%H%M%S)"

command_exists() { command -v "$1" >/dev/null 2>&1; }

if command_exists apt; then
  PKG_MANAGER="apt"
  UPDATE="sudo apt update"
  INSTALL="sudo apt install -y"
elif command_exists pacman; then
  PKG_MANAGER="pacman"
  UPDATE="sudo pacman -Syu"
  INSTALL="sudo pacman -S --noconfirm"
elif command_exists brew; then
  PKG_MANAGER="brew"
  UPDATE="brew update"
  INSTALL="brew install"
else
  echo "Unsupported package manager. Please install git, xclip, curl,
  make, unzip, gcc, ripgrep, python3, python3-pip, luarocks, trash-cli, fzf manually."
  exit 1
fi

echo "Installing $PKG_MANAGER packages..."
$UPDATE
$INSTALL git xclip curl make unzip gcc ripgrep python3 python3-pip luarocks trash-cli fzf

if ! command_exists cargo; then
  echo "Installing Rust and Cargo via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

if ! command_exists bob; then
  echo "Installing Bob via Cargo..."
  cargo install bob-nvim
fi

if ! bob list | grep -q "nightly"; then
  echo "Installing Neovim nightly via Bob..."
  bob install nightly
fi
echo "Setting Neovim nightly as default..."
bob use nightly

if ! grep -q "bob/nvim-bin" "$HOME/.bashrc"; then
  echo "Adding Bob's Neovim binary path to ~/.bashrc..."
  echo 'export PATH="$HOME/.local/share/bob/nvim-bin/:$PATH"' >> "$HOME/.bashrc"
fi

if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if ! command_exists node; then
    echo "Installing Node.js..."
    nvm install node
fi

if ! command_exists prettier; then
    echo "Installing prettier..."
    npm install -g prettier
fi

if ! command_exists black; then
    echo "Installing black..."
    python3 -m venv ~/nvim-venv
    source ~/nvim-venv/bin/activate
    pip3 install black
fi

if ! luarocks list --local | grep -q luv; then
    echo "Installing lua-luv..."
    luarocks install --local luv
fi

if [ -d "$NVIM_CONFIG_DIR" ]; then
  echo "Neovim config directory already exists at $NVIM_CONFIG_DIR."
  echo "Would you like to back it up before proceeding? (y/n)"
  read -r response
  if ["$response" = "y"] || ["$response" = "Y"]; then
    echo "Backing up existing config to $BACKUP_DIR..."
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
  else
    echo "Removing existing Neovim config directory..."
    rm -rf "$NVIM_CONFIG_DIR"
  fi
fi

echo "Cloning Neovim configuration from $REPO_URL..."
git clone "$REPO_URL" "$NVIM_CONFIG_DIR"

echo "Syncing Lazy.ncim plugins..."
nvim --headless -c 'Lazy sync' -c 'qa'

echo "Neovim configuration installed successfully!"
echo "Run ':Mason' and ':checkhealth' in Neovim to verify setup."



















echo "Dependencies installed. Run ':Mason' and ':checkhealth' in Neovim to verify."
