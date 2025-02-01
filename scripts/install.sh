#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display error messages and exit
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Navigate to the parent directory (assuming the script is inside the 'scripts' folder)
SOURCE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Define the Neovim plugin directory
PLUGIN_NAME="neoassistant-o1"  # Ensure this matches your actual plugin name
NVIM_PLUGIN_DIR="$HOME/.local/share/nvim/site/pack/plugins/start/$PLUGIN_NAME"

echo "Installing $PLUGIN_NAME Neovim plugin from local folder..."

# Ensure the destination directory exists
mkdir -p "$NVIM_PLUGIN_DIR" || error_exit "Failed to create plugin directory at $NVIM_PLUGIN_DIR."

# Check if rsync is installed
if ! command -v rsync &> /dev/null
then
    error_exit "rsync could not be found. Please install rsync to proceed."
fi

# Use rsync to copy files while excluding Git-related files and directories
rsync -av --exclude='.git/' --exclude='.gitignore' --exclude='README.md' --exclude='LICENSE' "$SOURCE_DIR"/ "$NVIM_PLUGIN_DIR"/ || error_exit "Failed to copy plugin files."

echo "$PLUGIN_NAME installed successfully to $NVIM_PLUGIN_DIR"

# Optional: Provide instructions for loading the plugin
echo "Ensure that Neovim's 'runtimepath' includes '$NVIM_PLUGIN_DIR'."
echo "Restart Neovim to load the $PLUGIN_NAME plugin."