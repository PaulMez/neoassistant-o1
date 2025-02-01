#!/bin/bash

# scripts/install.sh

# Variables
REPO_URL="https://github.com/yourusername/NeoAssistant-o1.git"  # Replace with your actual repo URL
PLUGIN_NAME="NeoAssistant-o1"
PLUGIN_DIR="$HOME/.local/share/nvim/site/pack/neoassistant-o1/start/$PLUGIN_NAME"

# Function to check if git is installed
check_git() {
    if ! command -v git &> /dev/null
    then
        echo "Git is not installed. Please install Git to proceed."
        exit 1
    fi
}

# Function to clone the repository
clone_repo() {
    if [ -d "$PLUGIN_DIR" ]; then
        echo "Plugin '$PLUGIN_NAME' is already installed."
    else
        echo "Cloning '$PLUGIN_NAME' from $REPO_URL..."
        mkdir -p "$HOME/.local/share/nvim/site/pack/neoassistant-o1/start/"
        git clone "$REPO_URL" "$PLUGIN_DIR"
        if [ $? -eq 0 ]; then
            echo "NeoAssistant-o1 installed successfully."
        else
            echo "Failed to clone the repository."
            exit 1
        fi
    fi
}

# Execute functions
check_git
clone_repo