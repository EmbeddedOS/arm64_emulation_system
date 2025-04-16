# 1. Select qemuboot.bbclass to build `runqemu`.
IMAGE_CLASSES += "qemuboot"

# 2. QEMU machine configuration.
QB_SYSTEM_NAME = "qemu-system-aarch64"
QB_MACHINE = "-machine virt,secure=on,virtualization=on"
QB_CPU = "-cpu cortex-a57"
QB_MEM = "-m 2048"

# Default FSTYPE to boot.
QB_DEFAULT_FSTYPE = "wic.qcow2"
QB_FSINFO = "wic:no-kernel-in-fs"

# Using rootfs as a virtio block device: "-drive id=disk0,file=@ROOTFS@,if=none,format=raw -device virtio-blk-device,drive=disk0"
# Using rootfs as an usb block device: "-device usb-ehci,id=ehci -drive if=none,file=@ROOTFS@,id=disk0,format=raw -device usb-storage,bus=ehci.0,drive=disk0"
# Using rootfs as mmc: "-device sdhci-pci,sd-spec-version=3 -drive if=none,file=@ROOTFS@,format=raw,id=mmc0 -device sd-card,drive=mmc0"

QB_ROOTFS_OPT = "-drive id=disk0,file=@ROOTFS@,if=none,format=qcow2 -device virtio-blk-device,drive=disk0"
QB_DEFAULT_BIOS = "flash.bin"

# Kernel parameters.
QB_KERNEL_ROOT = "/dev/mem"

# Network option.
#QB_TAP_OPT = "-netdev tap,id=net0,ifname=@TAP@,script=no,downscript=no"
#QB_NETWORK_DEVICE = "-device virtio-net-device,netdev=net0,mac=@MAC@"
QB_TAP_OPT = ""
QB_NETWORK_DEVICE = ""

# Serial option.
SERIAL_CONSOLES ?= "115200;ttyAMA0 115200;hvc0"
SERIAL_CONSOLES_CHECK = "${SERIAL_CONSOLES}"
QB_SERIAL_OPT = "-device virtio-serial-pci -chardev null,id=virtcon -device virtconsole,chardev=virtcon"
QB_TCPSERIAL_OPT = "-device virtio-serial-pci -chardev socket,id=virtcon,port=@PORT@,host=127.0.0.1 -device virtconsole,chardev=virtcon"

# Options to append to QEMU.
# QB_OPT_APPEND = "-device virtio-rng-device -device qemu-xhci -device usb-tablet -device usb-kbd"
