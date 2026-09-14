# LED Mute Fix (F4 / Fn+F4)

## Problem

On the ThinkPad E14 Gen 2 running Arch Linux with Hyprland, the mute key
(F4) correctly mutes the audio through `wpctl`, but the keyboard's mute
indicator LED does not turn on.

This happens because `thinkpad_acpi` exposes the LEDs through sysfs:

```text
/sys/class/leds/platform::mute
/sys/class/leds/platform::micmute
```

However, nothing automatically connects the PipeWire/PulseAudio mute status
to these LEDs. Minimal window managers such as Hyprland do not provide this
integration by default, unlike KDE Plasma or GNOME, which usually include
built-in support.

## How This Fix Works

1. The `toggle-mute.sh` and `toggle-micmute.sh` scripts replace direct
   `wpctl set-mute ... toggle` commands in the keybinds.
2. Each script toggles the audio state, checks the mute status, and writes
   `1` or `0` to the corresponding sysfs LED brightness file.
3. The `99-led-permissions.rules` udev rule grants the `input` group permission
   to write to the LED files, so the scripts do not need `sudo` every time
   they are triggered.

## Installation

### 1. Check whether the LEDs exist

Run:

```bash
ls /sys/class/leds/ | grep mute
```

The output should contain:

```text
platform::mute
platform::micmute
```

If the names are different, adjust the `LED_PATH` variable in both scripts.

### 2. Copy the scripts

Copy the scripts to your keybind directory. For example:

```bash
cp toggle-mute.sh toggle-micmute.sh ~/.config/hypr/hyprland/scripts/
chmod +x ~/.config/hypr/hyprland/scripts/toggle-mute.sh
chmod +x ~/.config/hypr/hyprland/scripts/toggle-micmute.sh
```

### 3. Install the udev rule

```bash
sudo cp 99-led-permissions.rules /etc/udev/rules.d/
sudo usermod -aG input $USER
sudo udevadm control --reload-rules
sudo udevadm trigger
```

### 4. Reboot

A reboot is required because the group membership change takes effect after
starting a new login session.

### 5. Update the Hyprland keybinds

Configure your mute keybinds to call these scripts instead of calling
`wpctl` directly.

For a Lua-based configuration such as `keybinds.lua`:

```lua
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(hyprScripts .. "/toggle-mute.sh"), { locked = true })
hl.bind("ALT + XF86AudioMute", hl.dsp.exec_cmd(hyprScripts .. "/toggle-micmute.sh"), { locked = true })
```

For a regular `hyprland.conf`:

```ini
bind = , XF86AudioMute, exec, ~/.config/hypr/scripts/toggle-mute.sh
bind = ALT, XF86AudioMute, exec, ~/.config/hypr/scripts/toggle-micmute.sh
```

## Debugging

If the LED still does not turn on after reboot, check whether your user is
a member of the `input` group:

```bash
groups
```

Then test the LED manually without `sudo`:

```bash
echo 1 > /sys/class/leds/platform::mute/brightness
```

If the command fails with `Permission denied`, the udev rule is not active
correctly. Check the rule and run:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```