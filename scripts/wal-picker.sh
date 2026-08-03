#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"      # Customize this path
TEMP_PREVIEW="/tmp/rofi_wallpaper_preview.png" # Temp file for preview

# Function to generate a temporary resized preview using feh
generate_preview() {
    feh --no-fehbg --force-aliasing --scale-down --geometry 300x200 --output-file "$TEMP_PREVIEW" "$1"
}

# Use 'find' to list all image files
WALLPAPERS=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \))

# Pipe the list to a while loop to interact with rofi and preview
SELECTED_WALLPAPER=$(
    echo "$WALLPAPERS" | while read -r wallpaper; do
        echo "$wallpaper"
    done | rofi -dmenu -i -p "Select Wallpaper" -format 'f' \
        -auto-select -selected-row 0 \
        -on-select 'generate_preview {f}' \
        -on-cancel 'rm -f "$TEMP_PREVIEW"' # Clean up temp file on cancel
)

# Clean up temp file after selection
rm -f "$TEMP_PREVIEW"

# Check if a wallpaper was selected and set it
if [ -n "$SELECTED_WALLPAPER" ]; then
    swww img "$SELECTED_WALLPAPER"
fi
