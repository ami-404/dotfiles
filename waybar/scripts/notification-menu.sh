#!/usr/bin/env bash

config="$HOME/.config/rofi/power-menu.rasi"

actions=$(echo -e "󰍛  Toggle Center\n󰂛  Do Not Disturb\n  Clear All")

# Show menu
selected_option=$(echo -e "$actions" | rofi -dmenu -i -config "${config}" || pkill -x rofi)

# Handle selection
case "$selected_option" in
*Toggle*)
    swaync-client -t
    ;;
*Disturb*)
    swaync-client -d toggle
    ;;
*Clear*)
    swaync-client -c
    ;;
esac
