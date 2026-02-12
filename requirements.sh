#!/bin/bash

set -e # Exit on error
set -u
set -o pipefail
# Define variables
NVIM_CONFIG_DIR="$HOME/.config/nvim"
# REPO_URL="git@github.com:desmondfowler/nvim-config.git"
# Default to https so install works without ssh keys
REPO_URL="${REPO_URL:-https://github.com/desmondfowler/nvim-config.git}"
BACKUP_DIR="$HOME/.config/nvim-backup-$(date +%Y%m%d%H%M%S)"
WAYLAND=false
if [ -n "${WAYLAND_DISPLAY-}" ] || [ "${XDG_SESSION_TYPE-}" = "wayland" ]; then
  WAYLAND=true
fi
command_exists() { command -v "$1" >/dev/null 2>&1; }

if command_exists apt; then
  PKG_MANAGER="apt"
  UPDATE="sudo apt update"
  INSTALL="sudo apt install -y git curl cmake make unzip gcc ripgrep python3 python3-venv python3-pip luarocks trash-cli fzf golang fd-find pkg-config libssl-dev"
elif command_exists pacman; then
  PKG_MANAGER="pacman"
  UPDATE="sudo pacman -Syu"
  INSTALL="sudo pacman -S --noconfirm git curl cmake make unzip gcc ripgrep python python-pip luarocks trash-cli fzf go fd openssl pkgconf"
elif command_exists brew; then
  PKG_MANAGER="brew"
  UPDATE="brew update"
  INSTALL="brew install git curl cmake make unzip gcc ripgrep python3 luarocks trash-cli fzf go fd"
elif command_exists dnf; then
  PKG_MANAGER="dnf"
  UPDATE="sudo dnf -y makecache"
  INSTALL="sudo dnf install -y git curl cmake make unzip gcc ripgrep python3 python3-pip python3-virtualenv luarocks trash-cli fzf golang fd-find openssl-devel pkgconf-pkg-config"
elif command_exists yum; then
  PKG_MANAGER="yum"
  UPDATE="sudo yum -y makecache"
  INSTALL="sudo yum install -y git curl cmake make unzip gcc ripgrep python3 python3-pip python3-virtualenv luarocks trash-cli fzf golang openssl-devel pkgconf-pkg-config"

else
  echo "Unsupported package manager. Please install git, xclip, curl,
  cmake, make, unzip, gcc, ripgrep, python3, python3-venv, python3-pip, luarocks,
  trash-cli, fzf, golang manually."
  exit 1
fi

echo "Installing $PKG_MANAGER packages..."
$UPDATE
$INSTALL
# Clipboard tool: Wayland -> wl-clipboard, X11 -> xclip
if $WAYLAND; then
  if ! command_exists wl-copy; then
    echo "Wayland detected; installing wl-clipboard..."
    if [ "$PKG_MANAGER" = "dnf" ] || [ "$PKG_MANAGER" = "yum" ]; then
      sudo "$PKG_MANAGER" install -y wl-clipboard
    elif [ "$PKG_MANAGER" = "apt" ]; then
      sudo apt install -y wl-clipboard
    elif [ "$PKG_MANAGER" = "pacman" ]; then
      sudo pacman -S --noconfirm wl-clipboard
    elif [ "$PKG_MANAGER" = "brew" ]; then
      brew install wl-clipboard
    fi
  fi
else
  if ! command_exists xclip; then
    echo "X11 detected; installing xclip..."
    if [ "$PKG_MANAGER" = "dnf" ] || [ "$PKG_MANAGER" = "yum" ]; then
      sudo "$PKG_MANAGER" install -y xclip
    elif [ "$PKG_MANAGER" = "apt" ]; then
      sudo apt install -y xclip
    elif [ "$PKG_MANAGER" = "pacman" ]; then
      sudo pacman -S --noconfirm xclip
    elif [ "$PKG_MANAGER" = "brew" ]; then
      brew install xclip
    fi
  fi
fi
if ! command_exists cargo; then
  echo "Installing Rust and Cargo via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # shellcheck source=/dev/null
  source "$HOME/.cargo/env"
fi

if ! command_exists bob; then
  echo "Installing Bob via Cargo..."
  cargo install bob-nvim
fi

if ! bob list | grep -q "nightly"; then
  echo "Installing Neovim nightly via Bob..."
  yes | bob install nightly
fi
echo "Setting Neovim nightly as default..."
yes | bob use nightly

if ! grep -q "bob/nvim-bin" "$HOME/.bashrc"; then
  echo "Adding Bob's Neovim binary path to ~/.bashrc..."
  # shellcheck disable=SC2016
  echo 'export PATH="$HOME/.local/share/bob/nvim-bin/:$PATH"' >> "$HOME/.bashrc"
fi
export PATH="$HOME/.local/share/bob/nvim-bin/:$PATH"

if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if ! command_exists node; then
    echo "Installing Node.js..."
    nvm install node
fi

if ! command_exists prettier; then
    echo "Installing prettier..."
    npm install -g prettier
fi

# if ! command_exists black; then
#     echo "Installing black..."
#     python3 -m venv ~/nvim-venv
#     source ~/nvim-venv/bin/activate
#     pip3 install neovim
#     pip3 install pynvim
#     pip3 install black
# fi
# Guarantee venv is made
NVIM_PY_VENV="${NVIM_PY_VENV:-$HOME/.local/share/nvim/venv}"
if [ ! -d "$NVIM_PY_VENV" ]; then
  echo "Creating Neovim python venv at $NVIM_PY_VENV..."
  python3 -m venv "$NVIM_PY_VENV"
fi
# shellcheck disable=SC1090
# shellcheck source=/dev/null
source "$NVIM_PY_VENV/bin/activate"
pip3 install -U pip >/dev/null
pip3 install -U pynvim black >/dev/null

if ! luarocks list --local | grep -q luv; then
    echo "Installing lua-luv..."
    luarocks install --local luv
fi

if [ -d "$NVIM_CONFIG_DIR" ]; then
  echo "Neovim config directory already exists at $NVIM_CONFIG_DIR."
  echo "Would you like to back it up before proceeding? (y/n)"
  read -r response
  if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
    echo "Backing up existing config to $BACKUP_DIR..."
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
  else
    echo "Removing existing Neovim config directory..."
    rm -rf "$NVIM_CONFIG_DIR"
  fi
fi

echo "Cloning Neovim configuration from $REPO_URL..."
git clone "$REPO_URL" "$NVIM_CONFIG_DIR"

echo "Syncing Lazy.nvim plugins..."
nvim --headless -c 'Lazy sync' -c 'qa'

echo "Neovim configuration installed successfully!"
echo "Run ':Mason' and ':checkhealth' in Neovim to verify setup."

echo "Dependencies installed. Run ':Mason' and ':checkhealth' in Neovim to verify."

if ! command -v nvim >/dev/null 2>&1; then
  echo "NOTE: nvim isn't on PATH in this current terminal yet."
  echo "Open a new terminal or run: source ~/.bashrc"
fi
