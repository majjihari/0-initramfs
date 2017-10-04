#!/bin/bash
set -ex

# make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-
MAKEOPTS="-j5"
BUILD_ARCH="armv6j-hardfloat-linux-gnueabi"
BUILD_HOST="x86_64-pc-linux-gnu"

apt-get update
apt-get install -y curl git xz-utils lbzip2 build-essential

mkdir -p /opt/cross-compile
pushd /opt/cross-compile

apt-get install -y wget build-essential xz-utils libgmp3-dev libmpc-dev gawk bc linux-headers-generic libncurses5-dev

rm -rf binutils-2.29
rm -rf mpfr-3.1.6
rm -rf gcc-6.4.0

wget -c http://ftp.gnu.org/gnu/binutils/binutils-2.29.tar.xz
wget -c http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.6.tar.xz
wget -c http://ftp.gnu.org/gnu/gcc/gcc-6.4.0/gcc-6.4.0.tar.xz
wget -c http://ftp.gnu.org/gnu/libc/glibc-2.26.tar.xz
wget -c https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.9.35.tar.xz

tar -xf binutils-2.29.tar.xz
tar -xf mpfr-3.1.6.tar.xz
tar -xf gcc-6.4.0.tar.xz
tar -xf glibc-2.26.tar.xz
tar -xf linux-4.9.35.tar.xz

pushd binutils-2.29
./configure --target=${BUILD_ARCH}
make ${MAKEOPTS}
make install
popd

pushd mpfr-3.1.6
./configure --target=${BUILD_ARCH}
make ${MAKEOPTS}
make install
popd

mkdir -p gcc-6.4.0-build
pushd gcc-6.4.0-build
../gcc-6.4.0/configure --enable-languages=c,c++ --disable-multilib --disable-shared --without-headers --disable-threads --disable-checking --target=${BUILD_ARCH}
make ${MAKEOPTS} all-gcc
make install-gcc
popd

pushd linux-4.9.35
make ARCH=arm INSTALL_HDR_PATH=/usr/local/${BUILD_ARCH}/ headers_install
popdi

mkdir -p glibc-2.26-build
pushd glibc-2.26-build
../glibc-2.26/configure --disable-multilib --target=${BUILD_ARCH} --host=${BUILD_ARCH} --build=${BUILD_HOST} --prefix=/usr/local/${BUILD_ARCH} --enable-add-ons
make install-bootstrap-headers=yes install-headers
popd

pushd gcc-6.4.0-build
make ${MAKEOPTS} all-target-libgcc
make install-target-libgcc
popd

# libstdc
pushd glibc-2.26-build
make ${MAKEOPTS}
make install
popd

# libstdc++
pushd gcc-6.4.0-build
make ${MAKEOPTS}
make
popd

exit 0

# git clone https://github.com/zero-os/0-initramfs /opt/0-initramfs

curl https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz > /tmp/go1.8.linux-amd64.tar.gz
tar -C /usr/local -xzf /tmp/go1.8.linux-amd64.tar.gz
mkdir /gopath

export PATH=$PATH:/usr/local/go/bin
export GOPATH=/gopath

cd /opt/0-initramfs
bash initramfs.sh --download


#
#
#
#


http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.tar.gz
http://download.savannah.gnu.org/releases/attr/attr-2.4.47.src.tar.gz
https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.24.tar.xz

# gettext
# ./configure --prefix /usr/local/armv6j-hardfloat-linux-gnueabi --build=x86_64-linux-gnu --host=armv6j-hardfloat-linux-gnueabi --disable-libasprintf --disable-java
# make && make install

# libattr
# ./configure --prefix /usr/local/armv6j-hardfloat-linux-gnueabi --build=x86_64-linux-gnu --host=armv6j-hardfloat-linux-gnueabi
# make install install-lib
# cd /usr/local/armv6j-hardfloat-linux-gnueabi/lib/ && ln -s libattr.so.1 libattr.so && cd -

# libcap
# make BUILD_CC=gcc CC=armv6j-hardfloat-linux-gnueabi-gcc AR=armv6j-hardfloat-linux-gnueabi-ar
# make prefix=/usr/local/armv6j-hardfloat-linux-gnueabi BUILD_CC=gcc CC=armv6j-hardfloat-linux-gnueabi-gcc AR=armv6j-hardfloat-linux-gnueabi-ar RAISE_SETFCAP=no install
# cp -rv /usr/local/armv6j-hardfloat-linux-gnueabi/lib64/* /usr/local/armv6j-hardfloat-linux-gnueabi/lib/

# https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-17.tar.gz
## tar -xzf kmod-17.tar.gz
## cd kmod-17/
## ./configure --host=arm-linux-gnueabi --prefix=/usr/arm-linux-gnueabi
# make
# make install

# -- parted --
# wget https://www.kernel.org/pub/linux/utils/util-linux/v2.30/util-linux-2.30.2.tar.xz
#

# ncurses
# export CPPFLAGS="-P"
# ./configure --prefix /usr/local/armv6j-hardfloat-linux-gnueabi --build=x86_64-linux-gnu --host=armv6j-hardfloat-linux-gnueabi --enable-widec
