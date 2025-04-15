inherit pkgconfig

require recipes-bsp/u-boot/u-boot.inc

SECTION = "bootloaders"
DEPENDS += "flex-native bison-native"

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=2ca5f2c35c8cc335f0a19756634782f1"

SRC_URI = "file://u-boot"

S = "${WORKDIR}/u-boot"
B = "${WORKDIR}/build"
