OnePlus 3T firmware updater
===========================
These scripts allow you to upgrade your firmware on your OnePlus 3T without doing a full flash of OxygenOS.  For example, you're using LineageOS and you need to update the firmware in order to flash the latest weekly build.

DISCLAIMER
----------
Use this at your own risk.  I am not responsible if you brick your phone. ;-)
I have tested these scripts on my own Oneplus 3T.

Requirements
------------
* Oneplus 3T
* LineageOS (bash needed; this could probably be eliminated)
* TWRP
* Latest [OnePlus OxygenOS zip](http://downloads.oneplus.net/oneplus-3t/).
* Root access

Usage
-----
# Reboot into recovery and mount the system partition.
# Back up your firmware!  This puts your current firmware in `/sdcard/flashable/firmware-backup`.  Copy this backup off of your phone and check the sha256sums.
```
/system/xbin/bash scripts/backup-firmware.sh
```
# Unzip the OxygenOS ROM.
```
cd /sdcard/
mkdir -p /sdcard/flashable/oxygen
cd /sdcard/flashable/oxygen
/system/xbin/unzip /sdcard/Download/OnePlus3TOxygen_28_OTA_028_all_1707141503_fc82c5d2e3054e44.zip
```
# Flash the firmware.
```
/system/xbin/bash scripts/flash-firmware.sh /sdcard/flashable/oxygen
reboot
```
