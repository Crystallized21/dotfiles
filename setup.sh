# Copyright (c) 2024 Crystallized21 <michael.bui_crystal@outlook.com>
# Released under the MIT license
# https://opensource.org/license/mit

#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles"

# List of files/folders to symlink
FILES=(
    ".zshrc"
    ".gitconfig"
    ".vimrc"
    "settings.json"
)

# Create symlinks for individual files
for file in "${FILES[@]}"; do
    src="$DOTFILES_DIR/$file"
    dest="$HOME/$file"

    # Backup existing file if it exists
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Backing up $dest to $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    # Create the symlink
    echo "Creating symlink: $src -> $dest"
    ln -s "$src" "$dest"
done

# Handle the .oh-my-zsh directory
OH_MY_ZSH_DIR="$DOTFILES_DIR/.oh-my-zsh"
if [ -d "$OH_MY_ZSH_DIR" ]; then
    # Backup existing .oh-my-zsh folder if it exists
    if [ -e "$HOME/.oh-my-zsh" ] || [ -L "$HOME/.oh-my-zsh" ]; then
        echo "Backing up $HOME/.oh-my-zsh to $HOME/.oh-my-zsh.backup"
        mv "$HOME/.oh-my-zsh" "$HOME/.oh-my-zsh.backup"
    fi

    # Create the symlink for the .oh-my-zsh folder
    echo "Creating symlink for .oh-my-zsh"
    ln -s "$OH_MY_ZSH_DIR" "$HOME/.oh-my-zsh"
else
    echo "No .oh-my-zsh directory found in your dotfiles"
fi

# Reload Zsh after applying changes
echo "Reloading Zsh configuration..."
exec zsh
