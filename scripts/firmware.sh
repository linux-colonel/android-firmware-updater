#!/system/xbin/bash

# global vars
unpack_dir="updater_unpacked"


function checkroot()
{
    uid=$(id -u)
    if [ $uid -ne 0 ]; then
            echo "This script must be run as root." >&2
            exit 1
    fi
}

function usage()
{
        echo "This script can flash, backup, and restore firmware to an Android device running LineageOS."
        echo "Warning: This script can brick your device.  Use at your own risk!"
        echo
	echo "Usage: $0 -f [-n] <updater-zip.zip>"
	echo "       $0 -b [-n] <backup-dir> <updater-zip.zip>"
	echo "       $0 -r [-n] <backup-dir> <updater-zip.zip>"
        echo "       $0 -h"
        echo
        echo "-f Flash mode:  Flashes the firmware from the updater zip to the device."
        echo
        echo "-b Backup mode: Backs up the firmware currently on the device to the backup directory."
        echo "    The updater zip is needed for the mapping of partitions to firmware images."
        echo
        echo "-r Restore mode: Restores the firmware from the backup directory to the device."
        echo "    The updater zip is needed for the mapping of partitions to firmware images."
        echo
        echo "-n NO-OP mode: This can be combined with the above modes to print what will be done without actually doing it.  This mode does not need root.  Use this first for extra safety."
        echo
        exit 1
}

function cleanup()
{
    rm -rf $unpack_dir
}

function process_updater()
{
    updater_zip=$1
    unzip -l $updater_zip 2>/dev/null |grep 'META-INF/com/google/android/updater-script' >/dev/null 2>&1
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "This does not appear to be an android updater file." >&2
        cleanup
        exit 1
    fi
    mkdir $unpack_dir
    pushd $unpack_dir >/dev/null
    echo "Unzipping update file."
    unzip $updater_zip >/dev/null 2>&1
    ret=$?
    popd >/dev/null
    if [ $ret -ne 0 ]; then
        echo "Failed to unzip updater." >&2
        exit 1
    fi
}

function confirm()
{
    echo "****WARNING****"
    echo "Only run this if you absolutely know what you're doing!"
    echo "THIS WILL BRICK YOUR PHONE OTHERWISE!"
    echo -n "Continue (y/N)"
    read ans

    if [ "$ans" != 'Y' ] && [ "$ans" != 'y' ]; then
            echo "You're not sure.  That's OK.  Quitting."
            exit 1
    fi
}

function do_flash()
{
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
}

function do_backup()
{
    # TODO
    echo "not implemented"
    exit 1
}

function do_restore()
{
    # TODO
    echo "not implemented"
    exit 1
}

# main script

OPTIND=1
unset noop flash backup restore
unset updater_zip backup_dir

while getopts "h?fbrn" opt; do
    case "$opt" in
    h)
        usage
        ;;
    f)
        flash=1
        ;;
    b)
        backup=1
        ;;
    r)if [ ! -d "$backup_dir" ]; then
        echo "backup-dir must be a directory" >&2
        exit 1
    fi
        restore=1
        ;;
    n)
        noop=1
        ;;
    *)
        usage
        ;;
    esac
done

shift $((OPTIND-1))

if [ $((flash+backup+restore)) -ne 1 ]; then
    echo "Exactly one of -f, -b, or -r must be specified." >&2
    usage
fi

if [ "$noop" ]; then
    echo "NO-OP mode activated!"
else
    checkroot
fi

if [ "$flash" ]; then
    echo "Running in flash mode."
    updater_zip=$1
    process_updater $updater_zip
fi

if [ "$backup" ]; then
    echo "Running in backup mode."
    backup_dir=$1
    updater_zip=$2
    if [ ! -d "$backup_dir" ]; then
        echo "backup-dir must be a directory" >&2
        exit 1
    fi
    process_updater $updater_zip
fi

if [ "$restore" ]; then
    echo "Running in restore mode."
    backup_dir=$1
    updater_zip=$2
    if [ ! -d "$backup_dir" ]; then
        echo "backup-dir must be a directory" >&2
        exit 1
    fi
    process_updater $updater_zip
fi

cleanup
exit 0

