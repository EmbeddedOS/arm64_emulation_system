COMPATIBLE_MACHINE:lava-machine = "lava-machine"
DEPENDS += "virtual/bootloader"

do_compile:append:lava-machine() {
    dd if=${BUILD_DIR}/bl1.bin of=${BUILD_DIR}/flash.bin bs=4096 conv=notrunc
    dd if=${BUILD_DIR}/fip.bin of=${BUILD_DIR}/flash.bin seek=64 bs=4096 conv=notrunc
}
