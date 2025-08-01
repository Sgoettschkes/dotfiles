#!/bin/bash

# File managed by Sgoettschkes/dotfiles
# Setup script for asdf plugins and tools

set -e

echo "Setting up asdf plugins and tools..."

# Check if asdf is installed
if ! command -v asdf &> /dev/null; then
    echo "Error: asdf is not installed. Please install asdf first."
    exit 1
fi

echo "Installing asdf plugins..."

# Erlang (needs to be installed before Elixir)
echo "Installing Erlang plugin..."
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git 2>/dev/null || echo "Erlang plugin already exists"

# Elixir (depends on Erlang)
echo "Installing Elixir plugin..."
asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git 2>/dev/null || echo "Elixir plugin already exists"

# Node.js and Yarn
echo "Installing Node.js plugin..."
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git 2>/dev/null || echo "Node.js plugin already exists"

echo "Installing Yarn plugin..."
asdf plugin add yarn https://github.com/twuni/asdf-yarn.git 2>/dev/null || echo "Yarn plugin already exists"

# PHP
echo "Installing PHP plugin..."
asdf plugin-add php https://github.com/asdf-community/asdf-php.git 2>/dev/null || echo "PHP plugin already exists"

# Python and Poetry
echo "Installing Python plugin..."
asdf plugin-add python https://github.com/danhper/asdf-python.git 2>/dev/null || echo "Python plugin already exists"

echo "Installing Poetry plugin..."
asdf plugin-add poetry https://github.com/asdf-community/asdf-poetry.git 2>/dev/null || echo "Poetry plugin already exists"

# Terraform
echo "Installing Terraform plugin..."
asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git 2>/dev/null || echo "Terraform plugin already exists"

# Golang
echo "Installing Golang plugin..."
asdf plugin-add golang https://github.com/asdf-community/asdf-golang.git 2>/dev/null || echo "Golang plugin already exists"

# jq
echo "Installing jq plugin..."
asdf plugin-add jq https://github.com/AZMCode/asdf-jq.git 2>/dev/null || echo "jq plugin already exists"

echo "All plugins installed successfully!"

# Set Erlang build options for better compatibility
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac --without-wx"
export KERL_BUILD_DOCS=yes

echo "Installing tools from .tool-versions..."
asdf install

echo "asdf setup complete!"
echo "Note: You may need to restart your shell or run 'asdf reshim' for changes to take effect."
