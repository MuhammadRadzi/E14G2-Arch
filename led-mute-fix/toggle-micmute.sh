#!/bin/bash
# Toggle mic mute (PipeWire/wpctl) and sync the ThinkPad mic-mute LED.

LED_PATH="/sys/class/leds/platform::micmute/brightness"

wpctl set-mute @DEFAULT_SOURCE@ toggle

if wpctl get-volume @DEFAULT_SOURCE@ | grep -q "MUTED"; then
  echo 1 > "$LED_PATH"
else
  echo 0 > "$LED_PATH"
fi
