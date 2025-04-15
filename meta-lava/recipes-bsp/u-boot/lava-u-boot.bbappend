# This config file will be merged with defconfig.
SRC_URI += "file://u-boot_tfa.cfg"

FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"
SRC_URI += "file://change-u-boot-targets-order.patch"
#SRC_URI += "file://add-u-boot-initial-env-build.patch"
