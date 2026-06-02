#!/bin/bash

set -euo pipefail

# Post-build script for buildroot to generate a .img flashable image for x86
# This script is called by buildroot after the build process is complete

ROOTFS=$(find output/images -name "rootfs.ext2" | head -n 1)
GRUB=$(find output/images -name "grub.img" | head -n 1)
BOOT=$(find output/ -name "boot.img" | head -n 1)
IMAGE="output/images/disk.img"

if [ -z "$GRUB" ] || [ -z "$ROOTFS" ] || [ -z "$BOOT" ]; then
    echo "Error: Could not find grub, boot, or rootfs images in output/images"
    exit 1
fi

# Copy the boot image to the output directory so it gets uploaded
cp $BOOT output/images/boot.img

ROOTFS_SIZE=$(stat -c%s "$ROOTFS")
IMAGE_SIZE=$((ROOTFS_SIZE + 10 * 1024 * 1024))
dd if=/dev/zero of="$IMAGE" bs=1 count=0 seek="$IMAGE_SIZE" status=none

dd if="$BOOT" of="$IMAGE" bs=512 count=1 conv=notrunc status=none
sfdisk --no-reread -q "$IMAGE" <<EOF
label: dos
unit: sectors
: start=2048, type=83, bootable
EOF

dd if="$GRUB" of="$IMAGE" bs=512 seek=1 conv=notrunc status=none
dd if="$ROOTFS" of="$IMAGE" bs=512 seek=2048 conv=notrunc status=none

echo "Flashable image ready: $IMAGE"
