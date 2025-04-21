#!/bin/bash

git clone https://github.com/ARM-software/arm-trusted-firmware.git
make CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- PLAT=qemu all fip DEBUG=1 BL33=../u-boot/u-boot.bin -j$(nproc) -C arm-trusted-firmware
dd if=arm-trusted-firmware/build/qemu/debug/bl1.bin of=flash.bin bs=4096 conv=notrunc
dd if=arm-trusted-firmware/build/qemu/debug/fip.bin of=flash.bin seek=64 bs=4096 conv=notrunc

make CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- PLAT=qemu all fip DEBUG=1 BL33=../linux/arch/arm64/boot/Image -j$(nproc) -C arm-trusted-firmware ARM_LINUX_KERNEL_AS_BL33=1
dd if=arm-trusted-firmware/build/qemu/debug/bl1.bin of=tfa_kernel.bin bs=4096 conv=notrunc
dd if=arm-trusted-firmware/build/qemu/debug/fip.bin of=tfa_kernel.bin seek=64 bs=4096 conv=notrunc
