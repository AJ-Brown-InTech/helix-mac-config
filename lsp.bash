#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Bootstrapping local language servers (macOS)..."

# -------------------------------
# Step 0: Ensure prerequisites
# -------------------------------

# Homebrew
if ! command -v brew &>/dev/null; then
  echo "🧪 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Core toolchain
echo "📦 Installing core dependencies..."
brew install node python rust pipx

# Ensure pipx is ready
pipx ensurepath >/dev/null

# Refresh PATH immediately
export PATH="$HOME/.local/bin:$PATH"

# -------------------------------
# Step 1: Define language server installs
# -------------------------------

# Homebrew packages — prune ones that commonly fail or aren’t in default taps
brew_install_servers=(
  "bash-language-server"
  "clangd"
  "cmake-language-server"
  "dockerfile-language-server-nodejs"
  "elixir-ls"
  "fortls"
  "gopls"
  "graphql-language-service-cli"
  "haskell-language-server"
  "jdtls"
  "jsonnet-language-server"
  "lua-language-server"
  "marksman"
  "nil"
  "phpactor"
  "pyright"
  "rust-analyzer"
  "solargraph"
  "taplo"
  "terraform-ls"
  "texlab"
  "typescript-language-server"
  "v-analyzer"
  "yaml-language-server"
)

npm_install_servers=(
  "vscode-langservers-extracted"
  "typescript-language-server"
  "yaml-language-server"
)

pipx_servers=(
  "ruff-lsp"
  "python-lsp-server"
)

cargo_servers=(
  "typos-lsp"
)

# -------------------------------
# Step 2: Install via Homebrew
# -------------------------------
echo "🍺 Installing via Homebrew..."
brew update
for pkg in "${brew_install_servers[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    echo "✅ $pkg already installed."
  else
    echo "➡️ Installing $pkg..."
    if ! brew install "$pkg"; then
      echo "⚠️  Failed to install $pkg (skipping)."
    fi
  fi
done

# -------------------------------
# Step 3: Install via npm
# -------------------------------
echo "📦 Installing via npm..."
for pkg in "${npm_install_servers[@]}"; do
  if npm list -g "$pkg" &>/dev/null; then
    echo "✅ $pkg already installed globally."
  else
    echo "➡️ Installing $pkg..."
    if ! npm install -g "$pkg"; then
      echo "⚠️  Failed to install $pkg with npm."
    fi
  fi
done

# -------------------------------
# Step 4: Install via pipx
# -------------------------------
echo "🐍 Installing via pipx..."
for pkg in "${pipx_servers[@]}"; do
  if pipx list | grep -q "$pkg"; then
    echo "✅ $pkg already installed."
  else
    echo "➡️ Installing $pkg..."
    if ! pipx install "$pkg"; then
      echo "⚠️  Failed to install $pkg with pipx."
    fi
  fi
done

# -------------------------------
# Step 5: Install via cargo
# -------------------------------
if command -v cargo &>/dev/null; then
  echo "🦀 Installing Rust-based tools..."
  for crate in "${cargo_servers[@]}"; do
    if cargo install --list | grep -q "$crate"; then
      echo "✅ $crate already installed."
    else
      echo "➡️ Installing $crate..."
      if ! cargo install "$crate" --locked; then
        echo "⚠️  Failed to install $crate with cargo."
      fi
    fi
  done
else
  echo "⚠️  cargo not found — skipping Rust-based language servers."
fi

echo -e "\n✅ All installable language servers bootstrapped!"
