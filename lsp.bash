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

# Install vscode-html-language-server
install_npm_package "vscode-langservers-extracted"

# Install vscode-css-language-server
# (Already installed with vscode-langservers-extracted)

# Install tailwindcss-language-server
install_npm_package "tailwindcss-language-server"

# Install eslint language server
install_npm_package "vscode-eslint-language-server"

# Install gopls
install_go_package "golang.org/x/tools/gopls"

# Install goimports
install_go_package "golang.org/x/tools/cmd/goimports"

# Install pyright
install_npm_package "pyright"

# Install ruff-lsp
pip install ruff-lsp

# Install black (Python formatter)
pip install black

# Install typescript-language-server
install_npm_package "typescript-language-server"

# Install prettier
install_npm_package "prettier"

# Install svelte-language-server
install_npm_package "svelte-language-server"

# Install ccls (C language server)
if command_exists apt-get; then
    sudo apt-get update && sudo apt-get install -y ccls
elif command_exists brew; then
    brew install ccls
else
    echo "Please install ccls manually for your system"
fi

# Install clang-format
if command_exists apt-get; then
    sudo apt-get update && sudo apt-get install -y clang-format
elif command_exists brew; then
    brew install clang-format
else
    echo "Please install clang-format manually for your system"
fi

# Install lldb-vscode
if command_exists apt-get; then
    sudo apt-get update && sudo apt-get install -y lldb
elif command_exists brew; then
    brew install llvm
else
    echo "Please install lldb manually for your system"
fi

# Install debugpy
pip install debugpy

echo "Installation complete. Please ensure that all installed binaries are in your PATH."
