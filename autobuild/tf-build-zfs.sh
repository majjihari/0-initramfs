#!/bin/bash
set -e

if [ "$1" == "" ] || [ "$2" == "" ]; then
    echo "[-] missing remote version or repository name"
    exit 1
fi

mkdir -p /target
rm -rf /target/*

# loading settings
. $(dirname $0)/tf-build-settings.sh

sed -i "/G8UFS_VERSION=/c\G8UFS_VERSION=\"$1\"" "/$2/packages/cores.sh"

# force follow 'development'
if [ "$1" == "development" ]; then
    sed -i "/CORES_VERSION=/c\CORES_VERSION=\"$1\"" "/$2/packages/cores.sh"
fi

# updating dependencies
cd "/$2/extensions/initramfs-gig"
git pull

# checkings arguments
arguments="--cores --kernel"
if [ "${1:0:7}" = "release" ]; then
    arguments="--cores --kernel --release"
fi

# start the build
cd "/$2"
bash initramfs.sh ${arguments}

# installing kernel to remote directory
cp "/$2/staging/vmlinuz.efi" /target/
