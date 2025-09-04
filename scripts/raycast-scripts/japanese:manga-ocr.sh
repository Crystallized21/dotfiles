#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Japanese/Manga OCR
# @raycast.mode fullOutput
# @raycast.packageName Japanese Tools

# Optional parameters:
# @raycast.icon 📷 

# Documentation:
# @raycast.description uses manga-ocr to grab japanese text from an image, and copys the output to the clipboard
# @raycast.author Crystallized21
# @raycast.authorURL https://raycast.com/Crystallized21

set -euo pipefail

MANGA_OCR_DIR="$HOME/tools/manga-ocr"
VENV_PATH="$MANGA_OCR_DIR/venv/bin/activate"
SCRIPT_PATH="$MANGA_OCR_DIR/manga_ocr_clipboard.py"

if [[ ! -d "$MANGA_OCR_DIR" ]]; then
  echo "Directory $MANGA_OCR_DIR does not exist." >&2
  exit 1
fi

if [[ ! -f "$VENV_PATH" ]]; then
  echo "Virtual environment not found at $VENV_PATH." >&2
  exit 1
fi

if [[ ! -f "$SCRIPT_PATH" ]]; then
  echo "Script $SCRIPT_PATH not found." >&2
  exit 1
fi

cd "$MANGA_OCR_DIR"
source "$VENV_PATH"
python "$SCRIPT_PATH"
