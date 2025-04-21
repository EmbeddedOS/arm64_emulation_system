#!/bin/bash
LINUX_VERSION=6.13.2

wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${LINUX_VERSION}.tar.xz
tar -xvf linux-${LINUX_VERSION}
mv linux-${LINUX_VERSION} linux
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- -C linux defconfig
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- -C linux