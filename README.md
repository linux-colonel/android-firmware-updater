Android Firmware Updater
========================

This script allows you to upgrade your firmware on your Android without doing a full flash of the stock ROM.  For example, you're using LineageOS and you need to update the firmware in order to flash the latest weekly build.

DISCLAIMER
----------

Use this at your own risk.  I am not responsible if you brick your phone. ;-)
I have tested these scripts on my own Oneplus 3T.

Requirements
------------

* LineageOS (or ROM with bash and unzip)
* Recovery-flashable zip containing firmware files.  See Assumptions section below for more details.
* Root access

Assumptions
-----------

* The script reads `META-INF/com/google/android/updater-script` to determine the mapping of firmware files to partitions. `package_extract_file` lines are the only lines considered.
* Partitions and firmware files with 'bak' in the name are ignored.  This is to avoid accidentally flashing backup partitions.  
* Firmware files must be in a directory at the root of the zip called either `firmware-update` or `RADIO`. 

Usage
-----

This script may be run as root from within Android.

1. Run the script in no-op mode first!  For extra safety, do NOT run it as root.  If it fails, do not continue.  Check to make sure what it's going to do is sane.
2. Become root.
3. Back up your firmware!  This puts your current firmware in the directory you specify.  Copy this backup off of your phone and check the sha256sums.
4. Flash your firmware.

