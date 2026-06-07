#!/bin/bash

# Start Waybar
waybar &

# Give Hyprland and Waybar a moment to start
sleep 0.5

# Left terminal: ncmpcpp
kitty --title="ncmpcpp" -e ncmpcpp &
sleep 0.4

# Move focus to the right
hyprctl dispatch movefocus r

# Right top terminal: cava
kitty --title="cava" -e cava &
sleep 0.4

# Split vertically on the right
hyprctl dispatch splitv

# Right bottom terminal: htop
kitty --title="htop" -e htop &
