#!/bin/bash

# scripts/uninstall.sh

# Variables
PLUGIN_NAME="NeoAssistant-o1"
PLUGIN_DIR="$HOME/.local/share/nvim/site/pack/neoassistant-o1/start/$PLUGIN_NAME"

# Function to uninstall the plugin
uninstall_plugin() {
    if [ -d "$PLUGIN_DIR" ]; then
        echo "Removing plugin '$PLUGIN_NAME'..."
        rm -rf "$PLUGIN_DIR"
        if [ $? -eq 0 ]; then
            echo "NeoAssistant-o1 uninstalled successfully."
        else
            echo "Failed to remove the plugin directory."
            exit 1
        fi
    else
        echo "Plugin '$PLUGIN_NAME' is not installed."
    fi
}

# Execute function
uninstall_plugin