ZEROTIER_VERSION="1.2.4"
ZEROTIER_CHECKSUM="f0b127bd0919e8af841336cd70a954a6"
ZEROTIER_LINK="https://github.com/zerotier/ZeroTierOne/archive/${ZEROTIER_VERSION}.tar.gz"

download_zerotier() {
    download_file $ZEROTIER_LINK $ZEROTIER_CHECKSUM zerotier-${ZEROTIER_VERSION}.tar.gz
}

extract_zerotier() {
    if [ ! -d "ZeroTierOne-${ZEROTIER_VERSION}" ]; then
        echo "[+] extracting: ZeroTierOne-${ZEROTIER_VERSION}"
        tar -xf ${DISTFILES}/zerotier-${ZEROTIER_VERSION}.tar.gz -C .
    fi
}

prepare_zerotier() {
    echo "[+] configuring zerotier"
}

compile_zerotier() {
    make one CC=${BUILDHOST}-gcc CXX=${BUILDHOST}-g++ STRIP=${BUILDHOST}-strip ${MAKEOPTS}
}

install_zerotier() {
    cp -av zerotier-cli zerotier-idtool zerotier-one "${ROOTDIR}/usr/bin/"
}

build_zerotier() {
    pushd "${WORKDIR}/ZeroTierOne-${ZEROTIER_VERSION}"

    prepare_zerotier
    compile_zerotier
    install_zerotier

    popd
}
