SUMMARY = "Lava Image"
IMAGE_INSTALL = "packagegroup-core-boot dropbear ${CORE_IMAGE_EXTRA_INSTALL} curl"
IMAGE_FEATURES = "allow-empty-password allow-root-login empty-root-password"
IMAGE_LINGUAS = " "
inherit core-image

IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE:append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "", d)}"
