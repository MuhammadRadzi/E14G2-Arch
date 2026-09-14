# Display Mode Switcher

A Windows+P-like display mode menu for Hyprland. It uses `fuzzel` as the
picker to switch between the laptop display and an external monitor
connected through HDMI.

## Features

The script provides four options through `fuzzel --dmenu`:

- **PC screen only** — only the laptop display is active
- **Duplicate** — mirrors the laptop display to the external monitor
- **Extend** — uses both displays side by side, with the external monitor
  positioned on the right
- **Second screen only** — only the external monitor is active

The script first checks whether an external monitor is detected through
`hyprctl monitors all`. If no external monitor is detected, it displays a
notification and exits.

## Requirements

- Hyprland with the `eDP-1` laptop output and `HDMI-A-1` external output.
  Adjust the `LAPTOP` and `EXTERNAL` variables at the beginning of the script
  if your output names are different. Check your output names with:

  ```bash
  hyprctl monitors all
  ```

- `fuzzel` — dmenu launcher
- `notify-send` — usually provided by `libnotify`

## Installation

```bash
cp display-mode.sh ~/.config/hypr/hyprland/scripts/
chmod +x ~/.config/hypr/hyprland/scripts/display-mode.sh
```

Then bind the script to a key of your choice. For example, in
`keybinds.lua`:

```lua
hl.bind("SUPER + P", hl.dsp.exec_cmd(hyprScripts .. "/display-mode.sh"))
```

Or in a regular `hyprland.conf`:

```ini
bind = SUPER, P, exec, ~/.config/hypr/scripts/display-mode.sh
```