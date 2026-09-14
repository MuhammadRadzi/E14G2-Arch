# SOF Microphone Fix

Fix internal microphone on Lenovo ThinkPad E14 Gen 2 running Arch Linux.

## Problem

The internal microphone is detected by ALSA/PipeWire, but recording produces no sound.

## Cause

Legacy audio configuration can force the wrong driver and codec model:

```text
options snd-intel-dspcfg dsp_driver=1
options snd-hda-intel model=laptop-dmic
```

On this laptop, the microphone works correctly with the Intel SOF driver.

## Fix

Install the required firmware and UCM configuration:

```fish
sudo pacman -S sof-firmware alsa-ucm-conf
```

Disable conflicting options if they exist:

```fish
sudoedit /etc/modprobe.d/intelaudio.conf
sudoedit /etc/modprobe.d/alsa-base.conf
```

Comment out these lines:

```text
# options snd-intel-dspcfg dsp_driver=1
# options snd-hda-intel model=laptop-dmic
```

Regenerate the initramfs:

```fish
sudo mkinitcpio -P
```

Then reboot:

```fish
systemctl reboot
```

## Verify

Check that SOF is loaded:

```fish
dmesg | grep -iE 'sof|dsp|dmic|snd|alc257'
```

Test the microphone:

```fish
pw-record --target 59 /tmp/mic-test.wav
```

Speak for several seconds, then press `Ctrl+C`:

```fish
pw-play /tmp/mic-test.wav
```

The source ID may differ. Find the correct source with:

```fish
wpctl status
```

## Notes

On the ThinkPad E14 Gen 2, the working source may appear as:

```text
Stereo Microphone
```

Avoid forcing `snd_hda_intel.dmic_detect=0`, because this laptop uses the SOF audio path and has detected digital microphones.
