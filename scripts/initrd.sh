#!/bin/bash

BUSYBOX_VERSION=1.36.1

wget https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2
tar -xvf busybox-${BUSYBOX_VERSION}.tar.bz2
mv busybox-${BUSYBOX_VERSION} busybox
make -j$(nproc) ARCH=arm CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- -C busybox defconfig
sed -i -e 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/g' busybox/.config
make -j$(nproc) ARCH=arm CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- -C busybox

# 4. Build rootfs.
mkdir -p rootfs/{bin,sbin,etc,proc,sys,usr/{bin,sbin},dev,lib,var/{log,run}}
cd rootfs

sudo mknod -m 660 rootfs/dev/mem c 1 1
sudo mknod -m 660 rootfs/dev/tty2 c 4 2
sudo mknod -m 660 rootfs/dev/tty3 c 4 3
sudo mknod -m 660 rootfs/dev/tty4 c 4 4
sudo mknod -m 660 rootfs/dev/null c 1 3
sudo mknod -m 660 rootfs/dev/zero c 1 5

cp -av busybox/_install/* rootfs/
ln -sf rootfs/bin/busybox rootfs/init

mkdir -p rootfs/etc/init.d/
cat > rootfs/etc/init.d/rcS << EOF0
# Mounting system...
mount -t sysfs none /sys
mount -t proc none /proc

# Configure networking for QEMU...
ifconfig lo up
ifconfig eth0 up
ip a add 10.0.2.15/255.255.255.0 dev eth0
route add default gw 10.0.2.2 eth0

cat > /etc/resolv.conf << EOF1
nameserver 10.0.2.3
EOF1
EOF0

chmod -R 777 rootfs/etc/init.d/rcS

cd rootfs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../rootfs.cpio.gz
cd ../
