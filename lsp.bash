#!/bin/bash

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

# Install Starship prompt
curl -sS https://starship.rs/install.sh | sh

echo 'starship init fish | source' >> ~/.config/fish/config.fish

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

# Install gopls & goimports
install_go_package "golang.org/x/tools/gopls"
install_go_package "golang.org/x/tools/cmd/goimports"

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
