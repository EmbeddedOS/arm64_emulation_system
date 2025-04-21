#!/bin/bash

qemu-system-aarch64 -machine virt -machine dumpdtb=qemu.dtb
qemu-system-aarch64 -M virt,virtualization=on,secure=on -cpu cortex-a57 -machine dumpdtb=secure_qemu.dtb

dd if=/dev/zero of=boot.img bs=1k count=20480
mkfs.ext4 boot.img
sudo mkdir -p /mnt/boot
sudo mount -o loop boot.img /mnt/boot
sudo cp linux/arch/arm64/boot/Image /mnt/boot/
sudo cp qemu.dtb /mnt/boot/
sudo cp secure_qemu.dtb /mnt/boot/
sudo cp rootfs.cpio.gz /mnt/boot/
sudo sync
sudo umount /mnt/boot
