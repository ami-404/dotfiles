#!/usr/bin/env bash

# Paths setup
IMG_DIR="$HOME/Pictures/images"
DATA_FILE="/tmp/eww_images.json"
INDEX_FILE="/tmp/eww_img_index.txt"

# 1. Scan directory and generate JSON array of absolute image paths
generate_json() {
    if [ ! -d "$IMG_DIR" ]; then
        echo "[]" > "$DATA_FILE"
        exit 1
    fi
    # Find common image types, sort them, and format into a valid JSON array
    find "$IMG_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | \
    sort | \
    jq -R . | jq -s . > "$DATA_FILE"
}

# 2. Setup initial tracking index
init_index() {
    if [ ! -f "$INDEX_FILE" ]; then
        echo "0" > "$INDEX_FILE"
    fi
}

# 3. Main execution commands
case "$1" in
    "scan")
        generate_json
        echo "0" > "$INDEX_FILE" # reset index on new scan
        ;;
    "next")
        init_index
        CURRENT=$(cat "$INDEX_FILE")
        TOTAL=$(jq 'length' "$DATA_FILE")
        
        # Increment index by 2 to show the next pair
        NEXT=$((CURRENT + 2))
        
        # Loop back to 0 if we exceed or hit the total count
        if [ "$NEXT" -ge "$TOTAL" ]; then
            NEXT=0
        fi
        echo "$NEXT" > "$INDEX_FILE"
        eww --config ~/.config/eww/wal-picker update img_index="$NEXT"
        ;;
    "prev")
        init_index
        CURRENT=$(cat "$INDEX_FILE")
        TOTAL=$(jq 'length' "$DATA_FILE")
        
        # Decrement index by 2 to show previous pair
        PREV=$((CURRENT - 2))
        
        # Wrap around to the last valid even pair if index drops below 0
        if [ "$PREV" -lt 0 ]; then
            PREV=$(( (TOTAL - 1) / 2 * 2 ))
        fi
        echo "$PREV" > "$INDEX_FILE"
        eww --config ~/.config/eww/wal-picker update img_index="$PREV"
        ;;
    *)
        # Default behavior: output data for Eww variables
        if [ "$2" == "index" ]; then
            init_index
            cat "$INDEX_FILE"
        else
            if [ ! -f "$DATA_FILE" ]; then generate_json; fi
            cat "$DATA_FILE"
        fi
        ;;
esac
