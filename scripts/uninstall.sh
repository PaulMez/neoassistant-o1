#!/bin/bash

NVIM_PLUGIN_DIR="$HOME/.local/share/nvim/site/pack/plugins/start/neoassistant-o1"

echo "Uninstalling Neovim plugin from $NVIM_PLUGIN_DIR..."

# Remove the plugin directory
if [ -d "$NVIM_PLUGIN_DIR" ]; then
    rm -rf "$NVIM_PLUGIN_DIR"
    echo "Plugin removed successfully!"
else
    echo "Plugin directory not found!"
fi