# QEMU

USB storage device: `-device usb-ehci,id=ehci -drive if=none,file=boot.img,id=image,format=raw -device usb-storage,bus=ehci.0,drive=image`
MMC device: `-device sdhci-pci,sd-spec-version=3 -drive if=none,file=boot.img,format=raw,id=MMC1 -device sd-card,drive=MMC1`
SATA device:  `-drive if=none,file=boot.img,id=mydisk -device ich9-ahci,id=ahci -device ide-drive,drive=mydisk,bus=ahci.0`
