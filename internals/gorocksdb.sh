ROCKSDB_VERSION="5.8"
ROCKSDB_CHECKSUM="44e3a4c3234ba715aae215488ee79bae"
ROCKSDB_LINK="https://github.com/facebook/rocksdb/archive/v${ROCKSDB_VERSION}.tar.gz"

download_gorocksdb() {
    download_file $ROCKSDB_LINK $ROCKSDB_CHECKSUM rocksdb-${ROCKSDB_VERSION}.tar.gz
}

extract_gorocksdb() {
    if [ ! -d "rocksdb-${ROCKSDB_VERSION}" ]; then
        echo "[+] extracting: rocksdb-${ROCKSDB_VERSION}"
        tar -xf ${DISTFILES}/rocksdb-${ROCKSDB_VERSION}.tar.gz -C .
    fi
}

prepare_rocksdb() {
    echo "[+] preparing rocksdb"
}

compile_rocksdb() {
    echo "[+] compiling rocksdb"

    export CC=${BUILDHOST}-gcc
    export CXX=${BUILDHOST}-g++
    export LDFLAGS="-L${ROOTDIR}/usr/lib"

    case ${BUILDARCH} in
        armv6*)
            export TARGET_ARCHITECTURE=armv6
            export CFLAGS="-I${ROOTDIR}/usr/include -march=${BUILDARCH}"
            ;;

        armv7*)
            export TARGET_ARCHITECTURE=armv7
            export CFLAGS="-I${ROOTDIR}/usr/include -march=${BUILDARCH}"
            ;;

        *)
            # export TARGET_ARCHITECTURE=
            export CFLAGS="-I${ROOTDIR}/usr/include"
            ;;
    esac

    PORTABLE=1 make ${MAKEOPTS} shared_lib
}

install_rocksdb() {
    echo "[+] installing rocksdb"
    cp -a librocksdb.so* "${ROOTDIR}"/usr/lib/
}

prepare_gorocksdb() {
    echo "[+] preparing gorocksdb"
    go get -d -v github.com/tecbot/gorocksdb
}

compile_gorocksdb() {
    echo "[+] compiling gorocksdb"

    export CGO_CFLAGS="-I${WORKDIR}/rocksdb-${ROCKSDB_VERSION}/include"
    # export CGO_LDFLAGS="-L${ROOTDIR}/usr/lib -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy -llz4"
    export CGO_LDFLAGS="-L${ROOTDIR}/usr/lib -lrocksdb -lstdc++ -lm -lz -lsnappy -llz4 -lbz2"
    export CC=${BUILDHOST}-gcc
    export CXX=${BUILDHOST}-g++
    export GOOS=linux
    export GOARCH=arm

    export GODEBUG=cgocheck=1

    go build
}

install_gorocksdb() {
    echo "[+] installing gorocksdb"
}

build_gorocksdb() {
    pushd "${WORKDIR}/rocksdb-${ROCKSDB_VERSION}"

    prepare_rocksdb
    compile_rocksdb
    install_rocksdb

    popd

    pushd "${GOPATH}/src/github.com/tecbot/gorocksdb"

    prepare_gorocksdb
    compile_gorocksdb
    install_gorocksdb

    popd
}
