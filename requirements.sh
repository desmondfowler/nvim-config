#!/bin/bash

set -e # Exit on error

command_exists() { command -v "$1" >/dev/null 2>&1; }

echo "Installing Neovim dependencies..."

echo "Download a Nerd Font (e.g., JetBrains Mono Nerd Font) from nerdfonts.com and install it manually."

echo "Installing APT packages..."
sudo apt update
sudo apt install -y git xclip curl make unzip gcc ripgrep python3 python3-pip luarocks trash-cli fzf

# Check if NVM is installed by testing for NVM_DIR
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load nvm
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
    python3 -m venv ~/venv
    source ~/venv/bin/activate
    pip3 install black
fi

if ! luarocks list --local | grep -q luv; then
    echo "Installing lua-luv..."
    luarocks install --local luv
fi

echo "Dependencies installed. Run ':Mason' and ':checkhealth' in Neovim to verify."
