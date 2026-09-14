# ThinkPad E14 Gen 2 — Arch Linux Scripts

A collection of scripts and fixes for hardware-specific issues and quirks
on the Lenovo ThinkPad E14 Gen 2 running Arch Linux with Hyprland.

Each directory contains a separate fix or topic, along with its own
`README.md` explaining the issue and installation steps.

## Contents

- [`led-mute-fix/`](./led-mute-fix) — Fixes the mute indicator LED on the F4
  key when audio is muted through PipeWire or `wpctl`.
- [`display-mode-switcher/`](./display-mode-switcher) — Provides a display
  mode switcher using `fuzzel`, similar to Windows+P.
- [`sof-microphone-fix/`](./sof-microphone-fix) — Fixes the internal
  microphone when it is detected but produces no sound.

## Target System

These scripts and fixes are intended primarily for the Lenovo ThinkPad E14
Gen 2 running Arch Linux and Hyprland.

Hardware behavior may vary depending on the BIOS version, kernel version,
audio configuration, and installed software.