# Display Mode Switcher

Script menu (mirip Windows+P) untuk pindah mode display di Hyprland lewat
`fuzzel` sebagai picker, antara layar laptop dan monitor eksternal via HDMI.

## Fitur

Menampilkan 4 pilihan lewat `fuzzel --dmenu`:

- **PC screen only** — hanya layar laptop aktif
- **Duplicate** — mirror layar laptop ke monitor eksternal
- **Extend** — layar laptop + monitor eksternal disusun berdampingan
  (eksternal di sebelah kanan)
- **Second screen only** — hanya monitor eksternal aktif

Script otomatis cek dulu apakah monitor eksternal terdeteksi lewat
`hyprctl monitors all`; kalau tidak, muncul notifikasi dan script berhenti.

## Requirement

- Hyprland dengan output `eDP-1` (laptop) dan `HDMI-A-1` (eksternal) —
  sesuaikan nama output di variabel `LAPTOP` dan `EXTERNAL` di awal script
  kalau berbeda. Cek nama output dengan:

  ```bash
  hyprctl monitors all
  ```

- `fuzzel` (dmenu launcher)
- `notify-send` (biasanya dari `libnotify`)

## Instalasi

```bash
cp display-mode.sh ~/.config/hypr/hyprland/scripts/
chmod +x ~/.config/hypr/hyprland/scripts/display-mode.sh
```

Lalu bind ke tombol pilihan, misalnya di `keybinds.lua`:

```lua
hl.bind("SUPER + P", hl.dsp.exec_cmd(hyprScripts .. "/display-mode.sh"))
```

Atau di `hyprland.conf` biasa:

```
bind = SUPER, P, exec, ~/.config/hypr/scripts/display-mode.sh
```
