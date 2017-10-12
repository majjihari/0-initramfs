NFTABLES_VERSION="0.7"
NFTABLES_CHECKSUM="4c005e76a15a029afaba71d7db21d065"
NFTABLES_LINK="https://www.netfilter.org/projects/nftables/files/nftables-${NFTABLES_VERSION}.tar.bz2"

LIBNFTNL_VERSION="1.0.7"
LIBNFTNL_CHECKSUM="82183867168eb6644926c48b991b8aac"
LIBNFTNL_LINK="http://www.iptables.org/projects/libnftnl/files/libnftnl-${LIBNFTNL_VERSION}.tar.bz2"

LIBMNL_VERSION="1.0.4"
LIBMNL_CHECKSUM="be9b4b5328c6da1bda565ac5dffadb2d"
LIBMNL_LINK="http://www.netfilter.org/projects/libmnl/files/libmnl-${LIBMNL_VERSION}.tar.bz2"

download_nftables() {
    download_file $NFTABLES_LINK $NFTABLES_CHECKSUM
    download_file $LIBNFTNL_LINK $LIBNFTNL_CHECKSUM
    download_file $LIBMNL_LINK $LIBMNL_CHECKSUM
}

extract_nftables() {
    if [ ! -d "nftables-${NFTABLES_VERSION}" ]; then
        echo "[+] extracting: nftables-${NFTABLES_VERSION}"
        tar -xf ${DISTFILES}/nftables-${NFTABLES_VERSION}.tar.bz2 -C .
    fi

    if [ ! -d "libnftnl-${LIBNFTNL_VERSION}" ]; then
        echo "[+] extracting: libnftnl-${LIBNFTNL_VERSION}"
        tar -xf ${DISTFILES}/libnftnl-${LIBNFTNL_VERSION}.tar.bz2 -C .
    fi

    if [ ! -d "libmnl-${LIBMNL_VERSION}" ]; then
        echo "[+] extracting: libmnl-${LIBNFTNL_VERSION}"
        tar -xf ${DISTFILES}/libmnl-${LIBMNL_VERSION}.tar.bz2 -C .
    fi
}

build_libmnl() {
    echo "[+] building libmnl"

    ./configure --prefix "${ROOTDIR}"/usr/ \
        --build ${BUILDCOMPILE} --host ${BUILDHOST}

    make ${MAKEOPTS}
    make install
}

build_libnftnl() {
    echo "[+] building libnftnl"
    export PKG_CONFIG_PATH=${ROOTDIR}/usr/lib/pkgconfig/

    ./configure --prefix "${ROOTDIR}"/usr/ \
        --build ${BUILDCOMPILE} --host ${BUILDHOST}

    make ${MAKEOPTS}
    make install
}

prepare_nftables() {
    echo "[+] preparing nftables"

    export LIBNFTNL_CFLAGS="-I${ROOTDIR}/usr/include"
    export LIBNFTNL_LIBS="-L${ROOTDIR}/usr/lib -lnftnl"

    ./configure --prefix "${ROOTDIR}"/usr \
        --build ${BUILDCOMPILE} --host ${BUILDHOST} \
        --disable-debug \
        --without-cli \
        --with-mini-gmp

    # Force to skip documentation compilation
    echo "all:" > doc/Makefile

    # Patching nftables
    if [ ! -f .patched_nftables-0.7-dest-ip-port.patch ]; then
        echo "[+] patching nftables"
        patch -p1 < "${PATCHESDIR}/nftables-0.7-dest-ip-port.patch"
        touch .patched_nftables-0.7-dest-ip-port.patch
    fi
}

compile_nftables() {
    echo "[+] compiling nftables"
    make ${MAKEOPTS}
}

install_nftables() {
    echo "[+] installing nftables"
    cp -a src/nft "${ROOTDIR}"/usr/sbin/
}

build_nftables() {
    pushd "${WORKDIR}/libmnl-${LIBMNL_VERSION}"
    build_libmnl
    popd

    pushd "${WORKDIR}/libnftnl-${LIBNFTNL_VERSION}"
    build_libnftnl
    popd

    pushd "${WORKDIR}/nftables-${NFTABLES_VERSION}"

    prepare_nftables
    compile_nftables
    install_nftables

    popd
}
