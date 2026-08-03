#!/bin/bash

if (pkill -x ~/projects/cpp/wifi-menu/menu); then
    ~/projects/cpp/wifi-menu/menu
else
    command ...
fi
pkill -x ~/projects/cpp/wifi-menu/menu || ~/projects/cpp/wifi-menu/menu
