
# Copyright (c) 2024 Crystallized21 <michael.bui_crystal@outlook.com>
# Released under the MIT license
# https://opensource.org/license/mit

$DotfilesDir = "$HOME\.dotfiles"

# List of files/folders to symlink
$Files = @(
    ".zshrc",
    ".gitconfig",
    ".gitignore",
    ".vimrc",
    "settings.json"
)

# Destination mappings
$Destinations = @{
    ".zshrc"       = "$HOME\.zshrc"
    ".gitconfig"   = "$HOME\.gitconfig"
    ".gitignore"   = "$HOME\.gitignore"
    ".vimrc"       = "$HOME\.vimrc"
    "settings.json"= "$HOME\AppData\Roaming\Code\User\settings.json"
}

# Create symbolic links for each file
foreach ($file in $Files) {
    $src = Join-Path -Path $DotfilesDir -ChildPath $file
    $dest = $Destinations[$file]

    if (-not $dest) {
        # Default destination if not explicitly mapped
        $dest = Join-Path -Path $HOME -ChildPath $file
    }

    # Backup existing file if it exists
    if (Test-Path $dest) {
        Write-Host "Backing up $dest to $dest.bak" -ForegroundColor Yellow
        Rename-Item -Path $dest -NewName "$dest.bak" -Force
    }

    # Create the symlink
    Write-Host "Creating symlink: $src -> $dest" -ForegroundColor Green
    New-Item -ItemType SymbolicLink -Path $dest -Target $src -Force
}

Write-Host "Dotfiles setup complete!" -ForegroundColor Cyan
