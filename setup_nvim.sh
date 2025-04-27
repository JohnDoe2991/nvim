#!/usr/bin/env bash

# Check for required tools
for tool in git curl tar; do
    if ! command -v "$tool" > /dev/null 2>&1; then
        echo "Error: $tool is not installed. Please install it and try again."
        exit 1
    fi
done

# Go to home directory
cd "$HOME" || exit 1

# Create .config if it doesn't exist
mkdir -p "$HOME/.config"

# Change to .config directory
cd "$HOME/.config" || exit 1

# Clone the GitHub repository (will fail if it already exists)
if [ ! -d "nvim" ]; then
    git clone https://github.com/JohnDoe2991/nvim
else
    echo "Directory ~/.config/nvim already exists. Skipping clone."
fi

# Download the Neovim tarball
curl -sL nvim-linux-x86_64.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz > nvim-linux64.tar.gz

# Determine whether we need sudo
SUDO=''
if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo > /dev/null 2>&1; then
        SUDO='sudo'
    else
        echo "Error: Script must be run as root or with sudo access."
        exit 1
    fi
fi

# Extract and install Neovim
$SUDO tar -xf nvim-linux-x86_64.tar.gz -C /usr --strip-components=1

# cleanup
rm nvim-linux-x86_64.tar.gz

echo "Neovim installed successfully!"
