#!/bin/bash

CHOICE=$(echo -e "🔔 Toggle Notification Center\n🚫 Do Not Disturb\n🧹 Clear All" | rofi -dmenu -p "swaync")

case "$CHOICE" in
"🔔 Toggle Notification Center")
    swaync-client -t
    ;;
"🚫 Do Not Disturb")
    swaync-client -d toggle
    ;;
"🧹 Clear All")
    swaync-client -c
    ;;
esac
