# ThinkPad E14 Gen 2 — Arch Linux Scripts

Kumpulan script dan fix untuk hal-hal spesifik hardware/quirk di ThinkPad
E14 Gen 2 yang menjalankan Arch Linux + Hyprland.

Setiap folder berisi satu fix/topik, dengan `README.md` sendiri yang
menjelaskan masalah dan cara pasang.

## Daftar isi

- [`led-mute-fix/`](./led-mute-fix) — LED indikator mute (F4) tidak menyala
  meski audio sudah ter-mute lewat PipeWire/wpctl.
- [`display-mode-switcher/`](./display-mode-switcher) — Menu switch mode
  display (PC screen only / Duplicate / Extend / Second screen only) lewat
  fuzzel, mirip Windows+P.
