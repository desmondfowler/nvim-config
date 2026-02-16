#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

NVIM_CONFIG_DIR="$HOME/.config/nvim"
REPO_URL="${REPO_URL:-https://github.com/desmondfowler/nvim-config.git}"
BACKUP_DIR="$HOME/.config/nvim-backup-$(date +%Y%m%d%H%M%S)"
NVIM_PY_VENV="${NVIM_PY_VENV:-$HOME/.local/share/nvim/venv}"
BOB_BIN_DIR="$HOME/.local/share/bob/nvim-bin"
FORCE_REPLACE=false
USE_EXISTING_CONFIG=false

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

log() {
  echo "==> $*"
}

require_command() {
  local cmd="$1"
  command_exists "$cmd" || die "Required command '$cmd' is unavailable."
}

ensure_command() {
  local cmd="$1"
  local installer_fn="$2"

  if ! command_exists "$cmd"; then
    "$installer_fn"
  fi

  command_exists "$cmd" || die "Command '$cmd' is unavailable after running '$installer_fn'."
}

usage() {
  cat <<'EOF'
Usage: ./requirements.sh [--force|-f] [--help|-h]

Options:
  -f, --force   Allow replacing ~/.config/nvim even if it is a dirty git repo.
  -e, --existing  Keep and use existing ~/.config/nvim (skip backup/remove/clone).
  -h, --help    Show this help message.
EOF
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -f|--force)
        FORCE_REPLACE=true
        ;;
      -e|--existing)
        USE_EXISTING_CONFIG=true
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unknown argument: $1. Use --help for usage."
        ;;
    esac
    shift
  done
}

append_line_once() {
  local file="$1"
  local line="$2"
  touch "$file"
  if ! grep -Fqx "$line" "$file"; then
    printf '%s\n' "$line" >> "$file"
  fi
}

persist_path_exports() {
  local local_bin_line="export PATH=\"\$HOME/.local/bin:\$PATH\""
  local cargo_line="export PATH=\"\$HOME/.cargo/bin:\$PATH\""
  local bob_line="export PATH=\"\$HOME/.local/share/bob/nvim-bin:\$PATH\""

  append_line_once "$HOME/.bashrc" "$local_bin_line"
  append_line_once "$HOME/.bashrc" "$cargo_line"
  append_line_once "$HOME/.bashrc" "$bob_line"
  append_line_once "$HOME/.zshrc" "$local_bin_line"
  append_line_once "$HOME/.zshrc" "$cargo_line"
  append_line_once "$HOME/.zshrc" "$bob_line"
  append_line_once "$HOME/.profile" "$local_bin_line"
  append_line_once "$HOME/.profile" "$cargo_line"
  append_line_once "$HOME/.profile" "$bob_line"

  export PATH="$HOME/.local/bin:$PATH"
  export PATH="$HOME/.cargo/bin:$PATH"
  export PATH="$BOB_BIN_DIR:$PATH"
}

install_system_packages() {
  if command_exists apt-get; then
    log "Detected Debian/Ubuntu (apt)."
    sudo apt-get update
    sudo apt-get install -y \
      git curl ca-certificates cmake make gcc unzip ripgrep \
      python3 python3-venv python3-pip luarocks trash-cli fzf \
      golang-go fd-find pkg-config libssl-dev clang libclang-dev nodejs npm \
      xclip wl-clipboard
  elif command_exists dnf; then
    log "Detected Fedora (dnf)."
    sudo dnf -y makecache
    sudo dnf install -y \
      git curl ca-certificates cmake make gcc unzip ripgrep \
      python3 python3-pip python3-virtualenv python3-devel \
      luarocks trash-cli fzf golang fd-find clang clang-devel llvm-devel nodejs npm \
      pkgconf-pkg-config openssl-devel \
      xclip wl-clipboard
  else
    echo "Unsupported distro for this script. Supported: Debian/Ubuntu and Fedora."
    exit 1
  fi
}

install_lua51_compat() {
  if command_exists lua5.1; then
    return 0
  fi

  log "Installing Lua 5.1 compatibility runtime (optional)..."
  if command_exists dnf; then
    if sudo dnf install -y compat-lua; then
      return 0
    fi
  elif command_exists apt-get; then
    if sudo apt-get install -y lua5.1; then
      return 0
    fi
  fi

  log "Lua 5.1 compatibility package not installed. Continuing."
  return 0
}

verify_core_commands() {
  local commands=(
    git curl cmake make gcc unzip rg python3 pip3 luarocks fzf go node npm
  )
  local cmd
  for cmd in "${commands[@]}"; do
    require_command "$cmd"
  done
}

ensure_fd_command() {
  if ! command_exists fd && command_exists fdfind; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi
}

install_rustup() {
  log "Installing Rust and Cargo via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

  if [ -f "$HOME/.cargo/env" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.cargo/env"
  fi
}

install_rust_if_needed() {
  ensure_command cargo install_rustup
}

install_tree_sitter_cli() {
  log "Installing tree-sitter CLI via Cargo..."
  if cargo install tree-sitter-cli; then
    return 0
  fi

  log "Cargo install failed (likely libclang/toolchain issue)."
  return 1
}

install_tree_sitter_via_pkg_manager() {
  if command_exists dnf; then
    if sudo dnf install -y tree-sitter-cli; then
      return 0
    fi
    if sudo dnf install -y tree-sitter; then
      return 0
    fi
  elif command_exists apt-get; then
    if sudo apt-get install -y tree-sitter-cli; then
      return 0
    fi
    if sudo apt-get install -y tree-sitter; then
      return 0
    fi
  fi

  return 1
}

install_tree_sitter_if_needed() {
  if command_exists tree-sitter; then
    return 0
  fi

  if install_tree_sitter_cli && command_exists tree-sitter; then
    return 0
  fi

  log "Cargo install failed; trying distro packages..."
  if install_tree_sitter_via_pkg_manager && command_exists tree-sitter; then
    return 0
  fi

  die "Unable to install tree-sitter CLI via Cargo or distro packages."
}

install_bob() {
  log "Installing Bob via Cargo..."
  cargo install bob-nvim
}

install_bob_and_neovim() {
  ensure_command bob install_bob
  log "Installing or updating Neovim nightly via Bob..."
  bob install nightly

  log "Setting Neovim nightly as default..."
  bob use nightly
}

install_prettier() {
  log "Installing prettier..."
  npm install -g prettier
}

install_node_and_prettier() {
  require_command node
  require_command npm
  ensure_command prettier install_prettier
}

install_python_venv() {
  if [ ! -d "$NVIM_PY_VENV" ]; then
    echo "Creating Neovim python venv at $NVIM_PY_VENV..."
    python3 -m venv "$NVIM_PY_VENV"
  fi

  "$NVIM_PY_VENV/bin/python" -m pip install -U pip pynvim >/dev/null
}

install_luarocks_luv() {
  require_command luarocks
  if ! luarocks list --local 2>/dev/null | grep -Eq '\bluv\b'; then
    log "Installing lua-luv..."
    luarocks install --local luv
  fi
}

abort_if_dirty_git_repo() {
  [ -d "$NVIM_CONFIG_DIR" ] || return 0
  command_exists git || return 0

  if git -C "$NVIM_CONFIG_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if [ -n "$(git -C "$NVIM_CONFIG_DIR" status --porcelain --untracked-files=normal)" ]; then
      if [ "$FORCE_REPLACE" != "true" ]; then
        die "Refusing to replace dirty git repo at $NVIM_CONFIG_DIR. Commit/stash changes first, or rerun with --force."
      fi
      log "Dirty git repo detected at $NVIM_CONFIG_DIR, continuing due to --force."
    fi
  fi
}

clone_or_replace_config() {
  if [ "$USE_EXISTING_CONFIG" = "true" ] && [ -d "$NVIM_CONFIG_DIR" ]; then
    log "Using existing config at $NVIM_CONFIG_DIR (clone/replace skipped)."
    return 0
  fi

  abort_if_dirty_git_repo

  if [ -d "$NVIM_CONFIG_DIR" ]; then
    log "Neovim config directory already exists at $NVIM_CONFIG_DIR."
    log "Back it up before proceeding? (y/n/e)"
    log "  y = backup then replace, n = replace without backup, e = keep existing"
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
      log "Backing up existing config to $BACKUP_DIR..."
      mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
    elif [ "$response" = "e" ] || [ "$response" = "E" ]; then
      log "Keeping existing config. Skipping clone/replace."
      return 0
    else
      log "Removing existing Neovim config directory..."
      rm -rf "$NVIM_CONFIG_DIR"
    fi
  fi

  log "Cloning Neovim configuration from $REPO_URL..."
  git clone "$REPO_URL" "$NVIM_CONFIG_DIR"
}

sync_lazy_plugins() {
  if ! command_exists nvim; then
    log "nvim is not on PATH in this shell yet."
    log "Open a new shell and run: nvim --headless -c 'Lazy sync' -c 'qa'"
    return
  fi

  log "Syncing Lazy.nvim plugins..."
  nvim --headless -c 'Lazy sync' -c 'qa'
}

main() {
  if [ "${EUID:-$(id -u)}" -eq 0 ]; then
    die "Run this script as your normal user, not as root."
  fi

  require_command sudo

  install_system_packages
  install_lua51_compat
  verify_core_commands
  ensure_fd_command
  install_rust_if_needed
  install_tree_sitter_if_needed
  persist_path_exports
  install_bob_and_neovim
  install_node_and_prettier
  install_python_venv
  install_luarocks_luv
  clone_or_replace_config
  sync_lazy_plugins

  log "Neovim configuration installed successfully."
  log "Run ':Mason' and ':checkhealth' in Neovim to verify setup."
  log "If nvim is not available immediately, open a new terminal or run: source ~/.bashrc or source ~/.zshrc"
}

parse_args "$@"
main
