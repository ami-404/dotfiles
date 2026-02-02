#!/bin/bash

# Toggle float
hyprctl dispatch togglefloating
# Set size
hyprctl dispatch resizeactive 70 20
# Move to center
hyprctl dispatch centerwindow
