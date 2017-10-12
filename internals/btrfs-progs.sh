BTRFS_VERSION="4.13.1"
BTRFS_CHECKSUM="f5140d4ece65ad297892b434699e9a37"
BTRFS_LINK="https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${BTRFS_VERSION}.tar.xz"

download_btrfs() {
    download_file $BTRFS_LINK $BTRFS_CHECKSUM
}

extract_btrfs() {
    if [ ! -d "btrfs-progs-v${BTRFS_VERSION}" ]; then
        echo "[+] extracting: btrfs-progs-${BTRFS_VERSION}"
        tar -xf ${DISTFILES}/btrfs-progs-v${BTRFS_VERSION}.tar.xz -C .
    fi
}

prepare_btrfs() {
    echo "[+] configuring btrfs-progs"
    PKG_CONFIG_PATH=/usr/local/armv6j-hardfloat-linux-gnueabi/lib/pkgconfig/ \
    ./configure --prefix /usr --disable-documentation --build ${BUILDCOMPILE} --host ${BUILDHOST}
}

compile_btrfs() {
    make ${MAKEOPTS}
}

install_btrfs() {
    make DESTDIR="${ROOTDIR}" install
}

build_btrfs() {
    pushd "${WORKDIR}/btrfs-progs-v${BTRFS_VERSION}"

    prepare_btrfs
    compile_btrfs
    install_btrfs

    popd
}
