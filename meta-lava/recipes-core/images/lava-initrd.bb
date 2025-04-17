DESCRIPTION = "Lava initrd"
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit deploy

BUSY_BOX_PV = "1.36.1"
LICENSE = "CLOSED"

SRC_URI = "https://busybox.net/downloads/busybox-${BUSY_BOX_PV}.tar.bz2;name=tarball \
           file://hello_initrd.c \
           file://busybox_defconfig \
           file://init \
           file://rcS"

SRC_URI[tarball.sha256sum] = "b8cc24c9574d809e7279c3be349795c5d5ceb6fdf19ca709f80cde50e47de314"

EXTRA_OEMAKE = "CC='${CC}' LD='${CCLD}' V=1 ARCH=${TARGET_ARCH} CROSS_COMPILE=${TARGET_PREFIX} SKIP_STRIP=y HOSTCC='${BUILD_CC}' HOSTCPP='${BUILD_CPP}'"

INITRD_INSTALL_DIR = "${D}/tmp-initrd"

B = "${WORKDIR}"
S = "${WORKDIR}"

DEPLOYDIR = "${WORKDIR}/deploy-${PN}"
FILES:${PN} = "${INITRD_IMAGE}"

do_configure() {
    cp busybox_defconfig busybox-${BUSY_BOX_PV}/.config
}

do_compile() {
    ${CC} hello_initrd.c -static -o hello_initrd.o
    oe_runmake -C busybox-${BUSY_BOX_PV}
}

do_install() {
    mkdir -p ${INITRD_INSTALL_DIR}
    oe_runmake CONFIG_PREFIX=${INITRD_INSTALL_DIR} -C busybox-${BUSY_BOX_PV} install

    mkdir -p ${INITRD_INSTALL_DIR}/proc
    mkdir -p ${INITRD_INSTALL_DIR}/etc
    mkdir -p ${INITRD_INSTALL_DIR}/sys
    mkdir -p ${INITRD_INSTALL_DIR}/dev
    mkdir -p ${INITRD_INSTALL_DIR}/lib
    mkdir -p ${INITRD_INSTALL_DIR}/var/log
    mkdir -p ${INITRD_INSTALL_DIR}/var/run
    mkdir -p ${INITRD_INSTALL_DIR}/var/run
    mkdir -p ${INITRD_INSTALL_DIR}/etc/init.d

    mknod -m 660 ${INITRD_INSTALL_DIR}/dev/mem c 1 1
    mknod -m 660 ${INITRD_INSTALL_DIR}/dev/tty2 c 4 2
    mknod -m 660 ${INITRD_INSTALL_DIR}/dev/tty3 c 4 3
    mknod -m 660 ${INITRD_INSTALL_DIR}/dev/tty4 c 4 4
    mknod -m 660 ${INITRD_INSTALL_DIR}/dev/null c 1 3
    mknod -m 660 ${INITRD_INSTALL_DIR}/dev/zero c 1 5

    install -m 0777 rcS ${INITRD_INSTALL_DIR}/etc/init.d
    install -m 0777 init ${INITRD_INSTALL_DIR}/init

    cp hello_initrd.o ${INITRD_INSTALL_DIR}/

    cd ${INITRD_INSTALL_DIR}
    find . -print0 | cpio --null -ov --format=newc | gzip -9 > ${D}/${INITRD_IMAGE}
    cd -

    # We don't install those temporary rootfs, delete to avoid QA do_package issues.
    rm -rf ${INITRD_INSTALL_DIR}
}

do_deploy() {
    cp ${D}/${INITRD_IMAGE} ${DEPLOYDIR}/
}

addtask deploy after do_install
