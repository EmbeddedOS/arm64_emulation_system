PACKAGE_SRC = "${TOPDIR}/../${PN}"
LINK_DL = "${TOPDIR}/tmp/link_download"
FILESEXTRAPATHS:prepend := "${LINK_DL}:"

def create_symlink(source_file, target_file):
    import os
    if os.path.islink(source_file):
        if os.readlink(source_file) == target_file:
            return
        else:
            os.unlink(source_file)
    os.symlink(target_file, source_file)
    return

python() {
    import os
    link_dl = d.getVar('LINK_DL')
    package_name = d.getVar('PN')
    package_src = d.getVar('PACKAGE_SRC')

    package_build = link_dl + '/' + package_name

    if not os.path.exists(link_dl):
        os.makedirs(link_dl, exist_ok=True)
    
    if package_src and os.path.exists(package_src):
        create_symlink(package_build, package_src)
}