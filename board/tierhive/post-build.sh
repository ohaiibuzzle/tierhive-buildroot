#!/bin/sh

set -u
set -e

BOARD_DIR=$(dirname "$0")

# Add a console on tty1
if [ -e "${TARGET_DIR}/etc/inittab" ]; then
    grep -qE '^tty1::' "${TARGET_DIR}/etc/inittab" || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100' "${TARGET_DIR}/etc/inittab"
fi

mkdir -p "${TARGET_DIR}/boot/grub"
cp "$BOARD_DIR/grub.cfg" "${TARGET_DIR}/boot/grub/grub.cfg"
