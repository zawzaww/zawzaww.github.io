---
layout: page
title: Android TWRP Build for Google Nexus 5X
dynamic_title: true
permalink: /projects/android-twrp-bullhead
---

![Image](https://play-lh.googleusercontent.com/2HtVAF5zfNMlmKhF0QYqCSr1rsstB1btNfdKl7WvGTcZkOSKCYNxdXwsSizx9VhiPg){: width="200" height="200" style="max-width: 100%" .normal}

TWRP Recovery 3.2.0 with F2FS File System Support for Google Nexus 5X.

This project is my TWRP android custom recovery build for Google Nexus 5X, included the abaility to convert your /data and /cache partitions to F2FS Filesystem. Supported F2FS File System by TWRP's inline Kernel, PureZ Kernel and TWRP 3.2.0 with added any features.

---

## What is TWRP
[TWRP - Team Win Recovery Project](https://twrp.me)

TWRP is a free and open-source Android custom recovery project. TWRP development is done by roughly 4 people at this point. Team Win was originally formed to work on porting WiMAX to CM7 for the HTC EVO 4G. Today, TWRP is the leading custom recovery for Android phones.
An android custom recovery is used for installing custom software on your android device. This custom software can include smaller modifications like rooting your device or even replacing the firmware of the device with a completely custom "ROM" like OmniROM.
You can find the source code for TWRP recovery at [https://github.com/omnirom/android_bootable_recovery.git](https://github.com/omnirom/android_bootable_recovery)

---

## Features
TWRP 3.2.0-0 Features:
by Dees_Troy
- Allow restoring adb backups in the TWRP GUI (bigbiff)
- Fix gzip backup error in adb backups (bigbiff)
- Fix a bug in TWRP's backup routines that occasionally corrupted backup files (nkk71)
- Better support for installing Android 8.0 based zips due to legacy props (nkk71)
- Support vold decrypt with keymaster 3.0 in 8.0 firmwares (nkk71)
- Decrypt of synthetic passwords for Pixel 2 (Dees_Troy)
- Support newer ext4 FBE policies for backup and restore in libtar (Dees_Troy)
- v2 fstab support (Dees_Troy)
- Bring TWRP forward to android 8.0 AOSP base (Dees_Troy)
- Various other minor bugfixes and tweaks

Added Features:
by Me
- F2FS File System Support
- Convert /data and /cache partitions to F2FS 
- Inline Kernel Build by PureZ Kernel
- Added F2FS and EXT4 dm blocks
- System partition never Mount on TWRP
- Default Brightness is 125 on TWRP
- Never Screen Timeout on TWRP
- Disable to install SuperSU Prompt
- and More.

---

## Installation
- Download twrp.img
- Copy twrp file to your PC's fastboot Folder
- Reboot your Phone to fastboot Mode
- Type this command
  ```
  fastboot flash recovery twrp.img
  ```
- Then, Reboot to Recovery
- Done

*Note: "twrp.img" is your twrp .img filename.*

---

## How to Convert to F2FS on TWRP
*Warning: Changing FileSystem is wipe your Data and InternalSD*

- Backup your Data ( You Don't forget/ *Important )
- Flash Recovery image
- Reboot to TWRP Recovery

For Data,
- Go to Wipe> Advanced Wipe
- Select "Data" and then, press "Change and Repair File System"
- Press Change File System
- Choose F2FS and Slide to Confirm
- Reboot

For Cache,
- Go to Wipe> Advanced Wipe
- Select "Cache" and then, press "Change and Repair File System"
- Press Change File System
- Choose F2FS and Slide to Confirm
- Reboot

---

## Download
[twrp-3.2.0-bullhead-3.2-zawzaw.img](https://androidfilehost.com/?fid=673791459329065215)

---

## Source Code
[https://github.com/zawzaww/twrp-device-bullhead](https://github.com/zawzaww/twrp-device-bullhead)

---

## XDA Thread
[TWRP 3.2.0 with F2FS Support for Google Nexus 5X](https://forum.xda-developers.com/nexus-5x/development/recovery-twrp-3-1-1-f2fs-support-nexus-t3619850)
