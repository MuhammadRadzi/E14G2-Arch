#!/bin/bash
# Toggle speaker mute (PipeWire/wpctl) and sync the ThinkPad F4 mute LED.

LED_PATH="/sys/class/leds/platform::mute/brightness"

wpctl set-mute @DEFAULT_SINK@ toggle

if wpctl get-volume @DEFAULT_SINK@ | grep -q "MUTED"; then
  echo 1 > "$LED_PATH"
else
  echo 0 > "$LED_PATH"
fi
