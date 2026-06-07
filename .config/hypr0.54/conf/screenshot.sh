#!/bin/bash

filename=$(date + '%Y-%m-%d-%H-%M-%S_hyprsht.png')
hyprshot -m output --silent -f "$filename" -o ~/Pictures/Screenshots  
notify-send "Screenshot captured" "saved as $filename to ~/Pictures/Screenshots"

