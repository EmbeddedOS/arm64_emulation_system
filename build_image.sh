#!/bin/bash
LINUX_VERSION=6.13.2
BUSYBOX_VERSION=1.36.1

# 1. Download toolchains.
wget https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
tar -xvf arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
mv arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu toolchain

# 2. Build kernel.
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${LINUX_VERSION}.tar.xz
tar -xvf linux-${LINUX_VERSION}
mv linux-${LINUX_VERSION} linux
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- -C linux defconfig
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- -C linux

# 3. Build busybox.
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

# 5. Build bootloader.
git clone https://github.com/ARM-software/u-boot.git
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- -C u-boot qemu_arm64_defconfig
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- -C u-boot

# 6. Build TF-A
git clone https://github.com/ARM-software/arm-trusted-firmware.git
make CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- PLAT=qemu all fip DEBUG=1 BL33=../u-boot/u-boot.bin -j$(nproc) -C arm-trusted-firmware
dd if=arm-trusted-firmware/build/qemu/debug/bl1.bin of=flash.bin bs=4096 conv=notrunc
dd if=arm-trusted-firmware/build/qemu/debug/fip.bin of=flash.bin seek=64 bs=4096 conv=notrunc

make CROSS_COMPILE=../toolchain/bin/aarch64-none-linux-gnu- PLAT=qemu all fip DEBUG=1 BL33=../linux/arch/arm64/boot/Image -j$(nproc) -C arm-trusted-firmware ARM_LINUX_KERNEL_AS_BL33=1
dd if=arm-trusted-firmware/build/qemu/debug/bl1.bin of=tfa_kernel.bin bs=4096 conv=notrunc
dd if=arm-trusted-firmware/build/qemu/debug/fip.bin of=tfa_kernel.bin seek=64 bs=4096 conv=notrunc
 

# 7. Dump QEMU device tree.
qemu-system-aarch64 -machine virt -machine dumpdtb=qemu.dtb
qemu-system-aarch64 -M virt,virtualization=on,secure=on -cpu cortex-a57 -machine dumpdtb=secure_qemu.dtb

# 7. TODO: Compress to final image.
dd if=/dev/zero of=boot.img bs=1k count=204800
mkfs.ext4 boot.img
sudo mkdir -p /mnt/boot
sudo mount -o loop emmc.img /mnt/boot
sudo cp linux/arch/arm64/boot/Image /mnt/boot/
sudo cp qemu.dtb /mnt/boot/
sudo cp rootfs.cpio.gz /mnt/boot/
sudo sync
sudo umount /mnt/boot
