# AArch64 emulation system

This repository setup a simplest Yocto build system to emulate a complete aarch64 Linux system (trusted-firmware-a, u-boot, kernel, initrd, rootfs). This might be helpful for those who want to:

- Understand all basic components in a Aarch64 Linux Embedded System and how they work together.
- Develop your own Linux distro, write BSP layer, and port components (kernel, u-boot, trusted-firmware-a) to your platform.
- Have hardware limitations or want to learn emulating with QEMU.

For more detail about the system, visit the [Main Blog](https://embeddedos.github.io/posts/simplest-emulation/).

## `meta-lava` layer

This layer contains minimal components to build an Aarch64 Linux distro run QEMU platform. This includes:

- 1 distro: `lava-distro`.
- 1 machine: `lava-machine`.
- And few recipes that build components from local sources.

The directory structure:

```text
meta-lava/
├── classes
│   └── lava_src.bbclass
├── conf
│   ├── distro
│   │   └── lava-distro.conf
│   ├── layer.conf
│   └── machine
│       ├── include
│       └── lava-machine.conf
├── README.md
├── recipes-bsp
│   ├── tfa
│   └── u-boot
├── recipes-core
│   └── images
├── recipes-kernel
│   └── linux
└── wic
    ├── lava-extlinux.cfg
    └── lava.wks
```

## Build system

To clone external repos (tfa, u-boot, kernel):

```bash
git submodule update --init
```

Build system:

```bash
kas checkout
kas build
```

And start emulating with `runqemu`:

```bash
source openembedded-core/oe-init-build-env
runqemu nographic
```

That's it 😛
