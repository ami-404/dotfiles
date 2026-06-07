#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
EWW_CMD="eww --config $HOME/.config/eww/wal-picker"

# SWWW configurations
FPS=60
TYPE="any"
DURATION=3
BEZIER="0.4,0.2,0.4,1.0"
SWWW_PARAMS="--transition-fps ${FPS} --transition-type ${TYPE} --transition-duration ${DURATION} --transition-bezier ${BEZIER}"

CACHE_FILE="/tmp/eww_wallpaper_list.txt"
INDEX_FILE="/tmp/eww_wallpaper_index.txt"

# Ensure cache exists
if [ ! -f "$CACHE_FILE" ] || [ "$1" == "init" ]; then
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) | sort > "$CACHE_FILE"
    echo "0" > "$INDEX_FILE"
fi

mapfile -t WALLPAPERS < "$CACHE_FILE"
TOTAL_WALLS=${#WALLPAPERS[@]}
CURRENT_INDEX=$(cat "$INDEX_FILE" 2>/dev/null || echo 0)

render_view() {
    YUCK="(box :orientation \"v\" :space-evenly false :class \"wall-list\""
    
    for i in {0..4}; do
        TARGET_IDX=$(( (CURRENT_INDEX + i) % TOTAL_WALLS ))
        if [ $TARGET_IDX -lt 0 ]; then TARGET_IDX=$((TOTAL_WALLS + TARGET_IDX)); fi
        
        IMG_PATH="${WALLPAPERS[$TARGET_IDX]}"
        
        # Build the button string using escaped double quotes for the inner arguments
        YUCK+=" (button :onclick \"$HOME/.config/eww/scripts/wall-selector.sh select \\\"$IMG_PATH\\\"\" :class \"wall-btn\""
        YUCK+="   (image :path \"$IMG_PATH\" :image-width 320 :image-height 180)"
        YUCK+=" )"
    done
    YUCK+=")"
    
    $EWW_CMD update wall_list_yuck="$YUCK"
}

case "$1" in
    "next")
        CURRENT_INDEX=$(( (CURRENT_INDEX + 1) % TOTAL_WALLS ))
        echo "$CURRENT_INDEX" > "$INDEX_FILE"
        render_view
        ;;
    "prev")
        CURRENT_INDEX=$(( (CURRENT_INDEX - 1 + TOTAL_WALLS) % TOTAL_WALLS ))
        echo "$CURRENT_INDEX" > "$INDEX_FILE"
        render_view
        ;;
    "select_current")
        # Grabs whichever wallpaper is currently sitting at the top index of the viewport
        CURRENT_WP="${WALLPAPERS[$CURRENT_INDEX]}"
        if [ -n "$CURRENT_WP" ] && [ -f "$CURRENT_WP" ]; then
            awww img "$CURRENT_WP" $SWWW_PARAMS
            wallust run "$CURRENT_WP" -s
            swaync-client -rs
            $EWW_CMD close wallpaper_selector
        fi
        ;;
    "select")
        # Ensure path argument is captured perfectly
        TARGET_WP="$2"
        if [ -n "$TARGET_WP" ] && [ -f "$TARGET_WP" ]; then
            awww img "$TARGET_WP" $SWWW_PARAMS
            wallust run "$TARGET_WP" -s
            swaync-client -rs
            $EWW_CMD close wallpaper_selector
        fi
        ;;
    *)
        echo "0" > "$INDEX_FILE"
        CURRENT_INDEX=0
        render_view
        $EWW_CMD open wallpaper_selector
        ;;
esac
