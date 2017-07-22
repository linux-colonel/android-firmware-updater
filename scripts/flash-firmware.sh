#!/system/xbin/bash
device=$(getprop ro.product.device)
if [ $device != "OnePlus3T" ] && [ $device != "oneplus3t" ]; then
	echo "Wrong device!  Quitting!" >&2
	exit 1
fi
uid=$(id -u)
if [ $uid -ne 0 ]; then
	echo "This script must be run as root." >&2
	exit 1
fi

update_dir=$1

if [ -z "$update_dir" ]; then
	echo "Usage: $0 <oneplus3t-unpacked-zip>"
	exit 1
fi

echo "****WARNING****"
echo "Only run this if you absolutely know what you're doing!"
echo "THIS WILL BRICK YOUR PHONE OTHERWISE!"
echo -n "Continue (y/N)"
read ans

if [ "$ans" != 'Y' ] && [ "$ans" != 'y' ]; then
	echo "You're not sure.  That's OK.  Quitting."
	exit 1
fi
echo "Beginning firmware update!"
echo "***DO NOT INTERRUPT***"
dd if=$update_dir/RADIO/static_nvbk.bin of=/dev/block/bootdevice/by-name/oem_stanvbk
dd if=$update_dir/firmware-update/cmnlib64.mbn of=/dev/block/bootdevice/by-name/cmnlib64
dd if=$update_dir/firmware-update/cmnlib.mbn of=/dev/block/bootdevice/by-name/cmnlib
dd if=$update_dir/firmware-update/hyp.mbn of=/dev/block/bootdevice/by-name/hyp
dd if=$update_dir/firmware-update/pmic.elf of=/dev/block/bootdevice/by-name/pmic
dd if=$update_dir/firmware-update/tz.mbn of=/dev/block/bootdevice/by-name/tz
dd if=$update_dir/firmware-update/emmc_appsboot.mbn of=/dev/block/bootdevice/by-name/aboot
dd if=$update_dir/firmware-update/devcfg.mbn of=/dev/block/bootdevice/by-name/devcfg
dd if=$update_dir/firmware-update/keymaster.mbn of=/dev/block/bootdevice/by-name/keymaster
dd if=$update_dir/firmware-update/xbl.elf of=/dev/block/bootdevice/by-name/xbl
dd if=$update_dir/firmware-update/rpm.mbn of=/dev/block/bootdevice/by-name/rpm
dd if=$update_dir/firmware-update/cmnlib64.mbn of=/dev/block/bootdevice/by-name/cmnlib64bak
dd if=$update_dir/firmware-update/cmnlib.mbn of=/dev/block/bootdevice/by-name/cmnlibbak
dd if=$update_dir/firmware-update/hyp.mbn of=/dev/block/bootdevice/by-name/hypbak
dd if=$update_dir/firmware-update/tz.mbn of=/dev/block/bootdevice/by-name/tzbak
dd if=$update_dir/firmware-update/emmc_appsboot.mbn of=/dev/block/bootdevice/by-name/abootbak
dd if=$update_dir/firmware-update/devcfg.mbn of=/dev/block/bootdevice/by-name/devcfgbak
dd if=$update_dir/firmware-update/keymaster.mbn of=/dev/block/bootdevice/by-name/keymasterbak
dd if=$update_dir/firmware-update/xbl.elf of=/dev/block/bootdevice/by-name/xblbak
dd if=$update_dir/firmware-update/rpm.mbn of=/dev/block/bootdevice/by-name/rpmbak
dd if=$update_dir/firmware-update/NON-HLOS.bin of=/dev/block/bootdevice/by-name/modem
dd if=$update_dir/firmware-update/adspso.bin of=/dev/block/bootdevice/by-name/dsp
dd if=$update_dir/firmware-update/BTFM.bin of=/dev/block/bootdevice/by-name/bluetooth

echo "Firmware update complete!"
exit 0

