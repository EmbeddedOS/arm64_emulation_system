
inherit kernel

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

SRC_URI = "file://linux-${PV}"

S = "${WORKDIR}/linux-${PV}"
B = "${WORKDIR}/build"

SRC_URI += "file://defconfig"
