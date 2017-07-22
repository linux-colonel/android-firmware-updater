#!/system/xbin/bash
device=$(getprop ro.product.device)
if [ $device != "OnePlus3T" ]; then
	echo "Wrong device!  Quitting!" >&2
	exit 1
fi
uid=$(id -u)
if [ $uid -ne 0 ]; then
	echo "This script must be run as root." >&2
	exit 1
fi
backup_dir=/sdcard/flashable/firmware-backup
mkdir -p $backup_dir

# do the backups
dd of=$backup_dir/static_nvbk.bin if=/dev/block/bootdevice/by-name/oem_stanvbk
dd of=$backup_dir/cmnlib64.mbn if=/dev/block/bootdevice/by-name/cmnlib64
dd of=$backup_dir/cmnlib.mbn if=/dev/block/bootdevice/by-name/cmnlib
dd of=$backup_dir/hyp.mbn if=/dev/block/bootdevice/by-name/hyp
dd of=$backup_dir/pmic.elf if=/dev/block/bootdevice/by-name/pmic
dd of=$backup_dir/tz.mbn if=/dev/block/bootdevice/by-name/tz
dd of=$backup_dir/emmc_appsboot.mbn if=/dev/block/bootdevice/by-name/aboot
dd of=$backup_dir/devcfg.mbn if=/dev/block/bootdevice/by-name/devcfg
dd of=$backup_dir/keymaster.mbn if=/dev/block/bootdevice/by-name/keymaster
dd of=$backup_dir/xbl.elf if=/dev/block/bootdevice/by-name/xbl
dd of=$backup_dir/rpm.mbn if=/dev/block/bootdevice/by-name/rpm
dd of=$backup_dir/cmnlib64.mbn.bak if=/dev/block/bootdevice/by-name/cmnlib64bak
dd of=$backup_dir/cmnlib.mbn.bak if=/dev/block/bootdevice/by-name/cmnlibbak
dd of=$backup_dir/hyp.mbn.bak if=/dev/block/bootdevice/by-name/hypbak
dd of=$backup_dir/tz.mbn.bak if=/dev/block/bootdevice/by-name/tzbak
dd of=$backup_dir/emmc_appsboot.mbn.bak if=/dev/block/bootdevice/by-name/abootbak
dd of=$backup_dir/devcfg.mbn.bak if=/dev/block/bootdevice/by-name/devcfgbak
dd of=$backup_dir/keymaster.mbn.bak if=/dev/block/bootdevice/by-name/keymasterbak
dd of=$backup_dir/xbl.elf.bak if=/dev/block/bootdevice/by-name/xblbak
dd of=$backup_dir/rpm.mbn.bak if=/dev/block/bootdevice/by-name/rpmbak
dd of=$backup_dir/NON-HLOS.bin if=/dev/block/bootdevice/by-name/modem
dd of=$backup_dir/adspso.bin if=/dev/block/bootdevice/by-name/dsp
dd of=$backup_dir/BTFM.bin if=/dev/block/bootdevice/by-name/bluetooth

# create checksums
pushd $backup_dir > /dev/null
sha256sum * > SHA256SUMS
popd > /dev/null

