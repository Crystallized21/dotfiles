# Copyright (c) 2024 Crystallized21 <michael.bui_crystal@outlook.com>
# Released under the MIT license
# https://opensource.org/license/mit

#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles"

# List of files to symlink
FILES=(
    ".zshrc"
    ".gitconfig"
    ".gitignore"
    ".vimrc"
    "settings.json"
)

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

# Reload Zsh configuration
echo "Reloading Zsh..."
exec zsh
