#!/bin/bash

# File managed by Sgoettschkes/dotfiles
# Setup script for asdf plugins and tools

# Don't exit on errors - we want to continue if one tool fails
set +e

echo "Setting up asdf plugins and tools..."

# Check if asdf is installed
if ! command -v asdf &> /dev/null; then
    echo "Error: asdf is not installed. Please install asdf first."
    exit 1
fi

echo "Installing asdf plugins..."

echo "Installing Erlang plugin..."
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git 2>/dev/null || echo "Erlang plugin already exists"

echo "Installing Elixir plugin..."
asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git 2>/dev/null || echo "Elixir plugin already exists"

echo "Installing Python plugin..."
asdf plugin add python https://github.com/danhper/asdf-python.git 2>/dev/null || echo "Python plugin already exists"

echo "Installing Poetry plugin..."
asdf plugin add poetry https://github.com/asdf-community/asdf-poetry.git 2>/dev/null || echo "Poetry plugin already exists"

echo "Installing Lua plugin..."
asdf plugin add lua https://github.com/Stratus3D/asdf-lua.git 2>/dev/null || echo "Lua plugin already exists"

echo "All plugins installed successfully!"

# Set Erlang build options for better compatibility
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac --without-wx"
export KERL_BUILD_DOCS=yes

echo "Installing tools from .tool-versions..."
echo "Note: If any tool fails to install, the script will continue with others..."

# Install tools one by one to avoid stopping on failures
failed_tools=()
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    # Extract tool name and version
    tool=$(echo "$line" | awk '{print $1}')
    version=$(echo "$line" | awk '{print $2}')

    echo "Installing $tool $version..."
    if asdf install "$tool" "$version"; then
        echo "✓ Successfully installed $tool $version"
    else
        echo "✗ Failed to install $tool $version"
        failed_tools+=("$tool $version")
    fi
done < "$HOME/.tool-versions"

echo "Reshimming to update PATH..."
asdf reshim

echo "asdf setup complete!"

if [ ${#failed_tools[@]} -gt 0 ]; then
    echo ""
    echo "⚠️  The following tools failed to install:"
    for tool in "${failed_tools[@]}"; do
        echo "  - $tool"
    done
    echo ""
    echo "You can try installing them manually later with: asdf install <tool> <version>"
else
    echo "✅ All tools installed successfully!"
fi

echo "Note: You may need to restart your shell for changes to take effect."
