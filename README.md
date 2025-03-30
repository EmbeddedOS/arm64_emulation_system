# Build full Linux system for Aarch64

Build a complete bootable Linux image (bootloader, rootfs, kernel, etc.) for Aarch64. The rootfs is made minimum with busybox.

```bash
./build_image.sh
```

To emulate bootloader:

```bash
qemu-system-aarch64 -machine virt -cpu cortex-a57 -bios u-boot.bin
```

To emulate kernel and rootfs:

```bash
qemu-system-aarch64 -kernel linux/arch/arm64/boot/Image -initrd rootfs.cpio.gz -machine virt -cpu cortex-a53 -m 1G -nographic -append "root=/dev/mem"
```

To emulate kernel and rootf with 2 network interfaces:

```bash
qemu-system-aarch64 -kernel linux/arch/arm64/boot/Image -initrd rootfs.cpio.gz -machine virt -cpu cortex-a53 -m 1G -nographic -append "root=/dev/mem" -netdev user,id=mynet0,hostfwd=tcp::8080-:80 -device e1000,netdev=mynet0 -net nic,macaddr=52:54:aa:12:35:02,model=virtio
```

Boot with MMC:

```bash
qemu-system-aarch64 -M virt,secure=on -cpu cortex-a57 -nographic -bios flash.bin -m 2048 -d int -device sdhci-pci,sd-spec-version=3 -drive if=none,file=emmc.img,format=raw,id=MMC1 -device sd-card,drive=MMC1
```

Boot with SATA:

```bash
qemu-system-aarch64 -M virt,secure=on -cpu cortex-a57 -nographic -bios u-boot/u-boot.bin -m 2048 -drive if=none,file=disk.img,id=mydisk -device ich9-ahci,id=ahci -device ide-drive,drive=mydisk,bus=ahci.0
```

Boot with virt block device:

```bash

```

Boot with USB:

```bash
qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -bios u-boot/u-boot.bin -m 2048 -device usb-ehci,id=ehci  -drive if=none,file=emmc.img,id=image,format=raw -device usb-storage,bus=ehci.0,drive=image
```

TODO: combine anything to final firmware image and emulating on that.
