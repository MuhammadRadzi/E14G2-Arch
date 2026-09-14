# SOF Microphone Fix

A fix for the internal microphone on the Lenovo ThinkPad E14 Gen 2 running
Arch Linux.

## Problem

The internal microphone is detected by ALSA and PipeWire, but recording
produces no sound.

## Cause

Legacy audio configuration can force an incompatible driver and codec model:

```text
options snd-intel-dspcfg dsp_driver=1
options snd-hda-intel model=laptop-dmic
```

On this laptop, the internal microphone works correctly with the Intel SOF
audio driver.

## Fix

Install the required firmware and UCM configuration:

```fish
sudo pacman -S sof-firmware alsa-ucm-conf
```

Disable the conflicting options if they exist:

```fish
sudoedit /etc/modprobe.d/intelaudio.conf
sudoedit /etc/modprobe.d/alsa-base.conf
```

Comment out the following lines:

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

## Verification

Check whether the SOF driver is loaded:

```fish
dmesg | grep -iE 'sof|dsp|dmic|snd|alc257'
```

Find the available audio sources:

```fish
wpctl status
```

Test the microphone by recording from the appropriate source:

```fish
pw-record --target 59 /tmp/mic-test.wav
```

Speak for several seconds, then press `Ctrl+C`.

Play the recording:

```fish
pw-play /tmp/mic-test.wav
```

The source ID may differ between systems or reboots. Use `wpctl status` to
find the correct source ID.

## Notes

On the ThinkPad E14 Gen 2, the working source may appear as:

```text
Stereo Microphone
```

Do not force `snd_hda_intel.dmic_detect=0`, because this laptop uses the SOF
audio path and detects digital microphones through it.