OPENSSL_VERSION="1.0.2j"
OPENSSL_CHECKSUM="96322138f0b69e61b7212bc53d5e912b"
OPENSSL_LINK="https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz"

download_openssl() {
    download_file $OPENSSL_LINK $OPENSSL_CHECKSUM
}

extract_openssl() {
    if [ ! -d "openssl-${OPENSSL_VERSION}" ]; then
        echo "[+] extracting: openssl-${OPENSSL_VERSION}"
        tar -xf ${DISTFILES}/openssl-${OPENSSL_VERSION}.tar.gz -C .
    fi
}

prepare_openssl() {
    echo "[+] preparing openssl"

    export CC="${BUILDHOST}-gcc"
    export AR="${BUILDHOST}-ar r"
    export RANLIB="${BUILDHOST}-ranlib"
    export CFLAGS="-fPIC"

    if [[ "${BUILDARCH}" == arm* ]]; then
        ./Configure shared --prefix=/usr linux-armv4
    else
        # FIXME: improve support
        ./Configure shared --prefix=/usr linux-x86_64
    fi
}

compile_openssl() {
    echo "[+] compiling openssl"
    make ${MAKEOPTS}
}

install_openssl() {
    make INSTALL_PREFIX="${ROOTDIR}" install

    # Removing useless ssl extra files
    rm -rf "${ROOTDIR}"/usr/ssl

    # Cleaning CFLAGS
    unset CFLAGS
    unset CC
    unset AR
    unset RANLIB
}

build_openssl() {
    pushd "${WORKDIR}/openssl-${OPENSSL_VERSION}"

    prepare_openssl
    compile_openssl
    install_openssl

    popd
}
