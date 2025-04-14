require recipes-bsp/trusted-firmware-a/trusted-firmware-a.inc

SECTION = "bootloaders"
LIC_FILES_CHKSUM += "file://docs/license.rst;md5=b2c740efedc159745b9b31f88ff03dde"
LICENSE = "BSD-3-Clause & MIT"
SRC_URI = "file://arm-trusted-firmware"

S = "${WORKDIR}/arm-trusted-firmware"
B = "${WORKDIR}/build"
