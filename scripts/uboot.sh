#!/bin/bash

git clone https://github.com/ARM-software/u-boot.git
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- -C u-boot qemu_arm64_defconfig
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- -C u-boot
