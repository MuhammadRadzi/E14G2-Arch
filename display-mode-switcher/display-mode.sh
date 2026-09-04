#!/bin/bash

LAPTOP="eDP-1"
EXTERNAL="HDMI-A-1"

if ! hyprctl monitors all | grep -q "$EXTERNAL"; then
    notify-send "Display" "Monitor eksternal tidak terdeteksi"
    exit 1
fi

CHOICE=$(printf "PC screen only\nDuplicate\nExtend\nSecond screen only" | fuzzel --dmenu --prompt "Display Mode: ")

case "$CHOICE" in
  "PC screen only")
    hyprctl eval "hl.monitor({ output = \"$LAPTOP\", disabled = false, position = \"0x0\" })"
    sleep 0.5
    hyprctl reload
    hyprctl eval "hl.monitor({ output = \"$EXTERNAL\", disabled = true })"
    notify-send "Display Mode" "PC screen only"
    ;;
  "Duplicate")
    hyprctl eval "hl.monitor({ output = \"$LAPTOP\", disabled = false, position = \"0x0\" })"
    sleep 0.5
    hyprctl reload
    hyprctl eval "hl.monitor({ output = \"$EXTERNAL\", disabled = false, mirror = \"$LAPTOP\" })"
    notify-send "Display Mode" "Duplicate"
    ;;
  "Extend")
    hyprctl eval "hl.monitor({ output = \"$EXTERNAL\", disabled = false })"
    sleep 0.7
    hyprctl eval "hl.monitor({ output = \"$EXTERNAL\", mirror = \"none\" })"
    sleep 0.3
    hyprctl eval "hl.monitor({ output = \"$LAPTOP\", disabled = false, position = \"0x0\" })"
    sleep 0.3
    hyprctl reload
    hyprctl eval "hl.monitor({ output = \"$EXTERNAL\", position = \"1920x0\" })"
    notify-send "Display Mode" "Extend"
    ;;
  "Second screen only")
    hyprctl eval "hl.monitor({ output = \"$EXTERNAL\", disabled = false, position = \"0x0\" })"
    sleep 0.5
    hyprctl reload
    hyprctl eval "hl.monitor({ output = \"$LAPTOP\", disabled = true })"
    notify-send "Display Mode" "Second screen only"
    ;;
esac