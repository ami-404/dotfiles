#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

FPS=60
TYPE="any"
DURATION=3
BEZIER="0.4,0.2,0.4,1.0"
SWWW_PARAMS="--transition-fps ${FPS} --transition-type ${TYPE} --transition-duration ${DURATION} --transition-bezier ${BEZIER}"

PICS=($(find -L "${WALLPAPER_DIR}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) | sort))
# PICS=($(find -L "${WALLPAPER_DIR}" -type f \( -iname \*.gif \) | sort))

RANDOM_PIC="${PICS[RANDOM % ${#PICS[@]}]}"

swww img "$RANDOM_PIC" ${SWWW_PARAMS}
wal -i "$RANDOM_PIC"
