### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=SAGA Kernel by @AndrewsPocoX7
do.devicecheck=0
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
do.check_boot_version=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
keycheck.timeout=10
'; } # end properties


### AnyKernel install
## boot shell variables
block=boot
is_slot_device=auto
ramdisk_compression=auto
patch_vbmeta_flag=auto
no_magisk_check=1

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh

# GKI check
kernel_version=$(cat /proc/version | awk -F '-' '{print $1}' | awk '{print $3}')
case $kernel_version in
    5.10*) ksu_supported=true ;;
    5.15*) ksu_supported=true ;;
    6.1*) ksu_supported=true ;;
    6.6*) ksu_supported=true ;;
    6.12*) ksu_supported=true ;;
    *) ksu_supported=false ;;
esac

ui_print " " "  -> Wild Kernels Supported: $ksu_supported"
$ksu_supported || abort "  -> Non-GKI device, abort."

# boot install
split_boot

if [ -f "$SPLITIMG/ramdisk.cpio" ]; then
    unpack_ramdisk
    write_boot
else
    flash_boot
fi

# SAGA: install the late-boot schedutil-enforcement script, if this
# build included it (kernel/addons/schedutil/'s Schedutil toggle) —
# copies to /data/adb/service.d/ so it (re)installs automatically on
# every flash, no manual step needed. Confirmed necessary on some
# MediaTek SoCs where a vendor HAL sets a different governor once,
# early in boot (see kernel/addons/schedutil/schedutil.sh in SAGA-Build
# for the full writeup). /data isn't always mounted/writable here (e.g.
# fastbootd) -- skip quietly rather than aborting the flash over it.
if [ -f "service.d/99schedutil.sh" ]; then
    if [ -d /data/adb ]; then
        mkdir -p /data/adb/service.d
        cp -f service.d/99schedutil.sh /data/adb/service.d/99schedutil.sh
        chmod 755 /data/adb/service.d/99schedutil.sh
        ui_print " " "SAGA: schedutil late-boot enforcement installed ✅"
    else
        ui_print " " "SAGA: schedutil script present but /data/adb not writable here — install manually if needed"
    fi
fi

ui_print " "
ui_print " "
ui_print " "
ui_print "SAGA Kernel Telegram Channel:"
ui_print " "
ui_print "!!!  https://t.me/sagakernellab  !!!"
ui_print " "
ui_print " "
ui_print "If you have any questions or need support, feel free to join our Telegram channel!" 
ui_print " "
ui_print " "
ui_print "Thank you for using SAGA Kernel! - @AndrewsPocoX7"
ui_print " "
ui_print " "