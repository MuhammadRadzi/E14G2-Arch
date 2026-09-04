# LED Mute Fix (F4 / Fn+F4)

## Masalah

Di ThinkPad E14 Gen 2 dengan Arch + Hyprland, tombol mute (F4) berfungsi mute
audio dengan benar lewat `wpctl`, tapi LED indikator mute di keyboard tidak
menyala. Ini terjadi karena `thinkpad_acpi` sudah mengekspos LED-nya lewat
sysfs (`/sys/class/leds/platform::mute` dan `platform::micmute`), tapi tidak
ada yang menjembatani status mute PipeWire/PulseAudio ke LED tersebut —
window manager minimal seperti Hyprland tidak melakukan ini secara otomatis
(beda dengan KDE Plasma/GNOME yang biasanya sudah punya integrasi bawaan).

## Cara kerja fix ini

1. Script `toggle-mute.sh` dan `toggle-micmute.sh` menggantikan pemanggilan
   `wpctl set-mute ... toggle` langsung di keybind. Script toggle audio
   seperti biasa, lalu cek status mute dan tulis `1`/`0` ke file LED terkait
   di sysfs.
2. udev rule `99-led-permissions.rules` memberi izin grup `input` untuk
   menulis ke file LED tersebut, supaya script tidak perlu `sudo` setiap
   toggle.

## Instalasi

1. Cek dulu apakah LED-nya ada di sistem kamu:

   ```bash
   ls /sys/class/leds/ | grep mute
   ```

   Harus muncul `platform::mute` dan `platform::micmute`. Kalau nama beda,
   sesuaikan `LED_PATH` di kedua script.

2. Copy script ke lokasi keybind kamu, misalnya:

   ```bash
   cp toggle-mute.sh toggle-micmute.sh ~/.config/hypr/hyprland/scripts/
   chmod +x ~/.config/hypr/hyprland/scripts/toggle-mute.sh
   chmod +x ~/.config/hypr/hyprland/scripts/toggle-micmute.sh
   ```

3. Pasang udev rule:

   ```bash
   sudo cp 99-led-permissions.rules /etc/udev/rules.d/
   sudo usermod -aG input $USER
   sudo udevadm control --reload-rules
   sudo udevadm trigger
   ```

4. **Reboot** (perubahan keanggotaan grup butuh sesi login baru).

5. Update keybind mute di config Hyprland kamu supaya memanggil script ini,
   bukan `wpctl` langsung. Contoh untuk config berbasis Lua
   (`keybinds.lua`):

   ```lua
   hl.bind("XF86AudioMute", hl.dsp.exec_cmd(hyprScripts .. "/toggle-mute.sh"), { locked = true })
   hl.bind("ALT + XF86AudioMute", hl.dsp.exec_cmd(hyprScripts .. "/toggle-micmute.sh"), { locked = true })
   ```

   Untuk config `hyprland.conf` biasa:

   ```
   bind = , XF86AudioMute, exec, ~/.config/hypr/scripts/toggle-mute.sh
   bind = ALT, XF86AudioMute, exec, ~/.config/hypr/scripts/toggle-micmute.sh
   ```

## Debug

Kalau LED masih tidak menyala setelah reboot:

```bash
# Pastikan sudah masuk grup input
groups

# Tes tulis manual tanpa sudo
echo 1 > /sys/class/leds/platform::mute/brightness
```

Kalau baris kedua gagal dengan "Permission denied", berarti udev rule belum
aktif dengan benar — cek ulang isi rule dan jalankan `udevadm trigger` lagi.
