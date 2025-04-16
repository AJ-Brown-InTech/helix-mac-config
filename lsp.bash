#!/bin/bash

# Ensure the script runs with sudo or appropriate permissions
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root or with sudo"
    exit 1
fi

# Detect package manager
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
elif command -v brew &> /dev/null; then
    PKG_MANAGER="brew"
elif command -v yay &> /dev/null; then
    PKG_MANAGER="yay"\else
    echo "No supported package manager found. Exiting."
    exit 1
fi

# Function to install a package if not already installed
install_package() {
    if ! command -v "$1" &> /dev/null; then
        echo "Installing $1..."
        case $PKG_MANAGER in
            apt) apt update && apt install -y "$1" ;;
            dnf) dnf install -y "$1" ;;
            brew) brew install "$1" ;;
            yay) yay -S --noconfirm "$1" ;;
        esac
    else
        echo "$1 is already installed. Skipping."
    fi
}

# Install language servers
install_package clangd   # C/C++
install_package gopls    # Go
install_package ruff     # Python linter
install_package rust-analyzer # Rust
install_package bufls    # Protobuf
install_package yaml-language-server # YAML
install_package typescript-language-server # TypeScript/JavaScript
install_package marksman # Markdown
install_package lua-language-server # Lua
install_package bash-language-server # Bash
install_package cmake-language-server # CMake
install_package vim-language-server # Vim script
install_package zls # Zig

# Install formatters
install_package prettier  # JavaScript/TypeScript/HTML/CSS
install_package goimports # Go
install_package black     # Python
install_package taplo     # TOML
install_package stylua    # Lua
install_package rustfmt   # Rust
install_package swift-format # Swift

# Install debuggers
install_package lldb      # C/C++/Rust debugger
install_package delve     # Go debugger

# Install additional tools
install_package tree-sitter-cli # Tree-sitter for syntax parsing
install_package jq        # JSON processing
install_package fd        # Fast file search
install_package ripgrep   # Better grep
install_package fzf       # Fuzzy finder

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install npm packages globally
install_npm_package() {
    if ! command_exists npm; then
        echo "npm is not installed. Please install Node.js and npm first."
        exit 1
    fi
    npm install -g "$1"
}

# Function to install Go packages
install_go_package() {
    if ! command_exists go; then
        echo "Go is not installed. Please install Go first."
        exit 1
    fi
    go install "$1"@latest
}

# Install Fisher (Fish package manager)
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# Install Fish plugins
fisher install jorgebucaran/nvm.fish
fisher install jethrokuan/z
fisher install PatrickF1/fzf.fish
fisher install franciscolourenco/done
fisher install jorgebucaran/autopair.fish

# Install apt-fast for faster package downloads
if command_exists apt-get; then
    sudo add-apt-repository -y ppa:apt-fast/stable
    sudo apt-get update && sudo apt-get install -y apt-fast
fi

# Install FZF (Fuzzy Finder)
if command_exists apt-get; then
    sudo apt-get install -y fzf
elif command_exists brew; then
    brew install fzf
else
    echo "Please install fzf manually."
fi

# Install exa (Better ls replacement)
if command_exists apt-get; then
    sudo apt-get install -y exa
elif command_exists brew; then
    brew install exa
else
    echo "Please install exa manually."
fi

# Install Git Delta (Better Git Diffs)
if command_exists apt-get; then
    sudo apt-get install -y git-delta
elif command_exists brew; then
    brew install git-delta
else
    echo "Please install git-delta manually."
fi

# Install various language servers
install_npm_package "vscode-langservers-extracted"
install_npm_package "tailwindcss-language-server"
install_npm_package "vscode-eslint-language-server"
install_npm_package "pyright"
install_npm_package "typescript-language-server"
install_npm_package "prettier"
install_npm_package "svelte-language-server"
install_npm_package "vscode-json-languageserver"

# Install gopls & goimports
install_go_package "golang.org/x/tools/gopls"
install_go_package "golang.org/x/tools/cmd/goimports"
install_go_package "github.com/go-delve/delve/cmd/dlv"  # Delve debugger

# Install Python tools
pip install ruff-lsp black debugpy

# Install C/C++ language servers & formatters
if command_exists apt-get; then
    sudo apt-get install -y ccls clang-format lldb
elif command_exists brew; then
    brew install ccls clang-format llvm
else
    echo "Please install C/C++ tools manually."
fi

# Optimize system swappiness for better performance
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Add cron job to auto-update system weekly
(crontab -l 2>/dev/null; echo "0 0 * * 7 sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y") | crontab -

echo "Installation complete. Please ensure that all installed binaries are in your PATH."