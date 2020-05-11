WIREGUARD_TOOLS_VERSION="1.0.20200102"
WIREGUARD_TOOLS_CHECKSUM="611eb05e295550f8267092bbf2731fd1"
WIREGUARD_TOOLS_LINK="https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-${WIREGUARD_TOOLS_VERSION}.tar.xz"

download_wireguard() {
    download_file $WIREGUARD_TOOLS_LINK $WIREGUARD_TOOLS_CHECKSUM
}

extract_wireguard() {
    if [ ! -d "wireguard-tools-${WIREGUARD_TOOLS_VERSION}" ]; then
        echo "[+] extracting: wireguard-tools-${WIREGUARD_TOOLS_VERSION}"
        tar -xf ${DISTFILES}/wireguard-tools-${WIREGUARD_TOOLS_VERSION}.tar.xz -C .
    fi
}

prepare_wireguard_modules() {
    echo "[+] preparing wireguard (kernel module upstream)"
}

compile_wireguard_tools() {
    echo "[+] compiling wireguard (tools)"
    make ${MAKEOPTS}
}

install_wireguard_tools() {
    echo "[+] installing wireguard (tools)"
    make DESTDIR=${ROOTDIR} install
}

build_wireguard() {
    pushd "${WORKDIR}/wireguard-tools-${WIREGUARD_TOOLS_VERSION}/src"
    compile_wireguard_tools
    install_wireguard_tools
    popd
}

registrar_wireguard() {
    DOWNLOADERS+=(download_wireguard)
    EXTRACTORS+=(extract_wireguard)
}

registrar_wireguard
