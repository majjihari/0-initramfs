IPROUTE2_VERSION="4.13.0"
IPROUTE2_CHECKSUM="69dc9e3ece3296890278f0de478330c8"
IPROUTE2_LINK="https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-${IPROUTE2_VERSION}.tar.xz"

download_iproute2() {
    download_file $IPROUTE2_LINK $IPROUTE2_CHECKSUM
}

extract_iproute2() {
    if [ ! -d "iproute2-${IPROUTE2_VERSION}" ]; then
        echo "[+] extracting: iproute2-${IPROUTE2_VERSION}"
        tar -xf ${DISTFILES}/iproute2-${IPROUTE2_VERSION}.tar.xz -C .
    fi
}

prepare_iproute2() {
    echo "[+] preparing iproute2"

    export CC="${BUILDHOST}-gcc"
    export AR="${BUILDHOST}-ar"
    export RANLIB="${BUILDHOST}-ranlib"

    PKG_CONFIG_PATH=${ROOTDIR}/lib/pkgconfig/ \
      ./configure ${ROOTDIR}/usr/include
}

compile_iproute2() {
    echo "[+] compiling iproute2"
    make ${MAKEOPTS}
}

install_iproute2() {
    echo "[+] installing iproute2"

    # Replace busybox symlink with the real binary
    rm -f "${ROOTDIR}"/sbin/ip
    cp -a ip/ip "${ROOTDIR}"/sbin/ip
    mkdir -p "${ROOTDIR}"/var/run/netns
}

build_iproute2() {
    pushd "${WORKDIR}/iproute2-${IPROUTE2_VERSION}"

    prepare_iproute2
    compile_iproute2
    install_iproute2

    popd
}
