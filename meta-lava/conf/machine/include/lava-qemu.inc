# 1. Select qemuboot.bbclass to build `runqemu`.
IMAGE_CLASSES += "qemuboot"

# 2. QEMU machine configuration.
QB_SYSTEM_NAME = "qemu-system-aarch64"
QB_MACHINE = "-machine virt"
QB_CPU = "-cpu cortex-a57"

# Default FSTYPE to boot.
QB_DEFAULT_FSTYPE = "wic"
QB_FSINFO = "wic:no-kernel-in-fs"

# Using rootfs as a virtio block device: "-drive id=disk0,file=@ROOTFS@,if=none,format=raw -device virtio-blk-device,drive=disk0"
# Using rootfs as an usb block device: "-device usb-ehci,id=ehci -drive if=none,file=@ROOTFS@,id=disk0,format=raw -device usb-storage,bus=ehci.0,drive=disk0"
# Using rootfs as mmc:
QB_ROOTFS_OPT = "-device sdhci-pci,sd-spec-version=3 -drive if=none,file=@ROOTFS@,format=raw,id=mmc0 -device sd-card,drive=mmc0"

# Kernel parameters.
QB_KERNEL_ROOT = "/dev/mmcblk0p2"
QB_KERNEL_CMDLINE_APPEND = "console=ttyAMA0 systemd.mask=systemd-networkd"

# Network option.
#QB_TAP_OPT = "-netdev tap,id=net0,ifname=@TAP@,script=no,downscript=no"
#QB_NETWORK_DEVICE = "-device virtio-net-device,netdev=net0,mac=@MAC@"

# Serial option.
QB_SERIAL_OPT = ""
QB_TCPSERIAL_OPT = ""
#QB_TCPSERIAL_OPT = "-device virtio-serial-device -chardev socket,id=virtcon,port=@PORT@,host=127.0.0.1 -device virtconsole,chardev=virtcon"

# Options to append to QEMU.
QB_OPT_APPEND = "-device virtio-rng-device"