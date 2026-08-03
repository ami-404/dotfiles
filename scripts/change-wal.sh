#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
WALLPAPER_DIR2="$HOME/Pictures/wallpapers/orangci-wall"

FPS=60
TYPE="any"
DURATION=3
BEZIER="0.4,0.2,0.4,1.0"
SWWW_PARAMS="--transition-fps ${FPS} --transition-type ${TYPE} --transition-duration ${DURATION} --transition-bezier ${BEZIER}"

PICS=($(find -L "${WALLPAPER_DIR2}" "${WALLPAPER_DIR}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) | sort))
# PICS=($(find -L "${WALLPAPER_DIR}" -maxdepth 3 -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) | sort))
# PICS=($(find -L "${WALLPAPER_DIR}" -type f \( -iname \*.gif \) | sort))

if [ $1 ]; then
  SELECTED="$1"
else
  SELECTED="${PICS[RANDOM % ${#PICS[@]}]}"
fi

awww img "$SELECTED" $SWWW_PARAMS
wallust run "$SELECTED" -s
# swaync-client -rs
# wal -i "$RANDOM_PIC"
