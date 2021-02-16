#!/bin/bash
set -e

cd staging

kernel=zero-os-${IMAGE_BRANCH}-generic-${GITHUB_SHA:0:10}.efi
linkname=zero-os-${IMAGE_BRANCH}-generic.efi

echo "[+] kernel: ${kernel}"
echo "[+] branch: ${linkname}"

cp vmlinuz.efi "${kernel}"

#curl -k -b "token=${BOOTSTRAP_TOKEN}" -X POST -F "kernel=@${kernel}" "https://bootstrap.ogmesh.com/api/kernel"
#curl -k -b "token=${BOOTSTRAP_TOKEN}" "https://bootstrap.ogmesh.com/api/symlink/${linkname}/${kernel}"

curl -k -b "token=${BOOTSTRAP_TOKEN}" -X POST -F "kernel=@${kernel}" "http://unsecure-bootstrap.ogmesh.com/api/kernel"
curl -k -b "token=${BOOTSTRAP_TOKEN}" "http://unsecure-bootstrap.ogmesh.com/api/symlink/${linkname}/${kernel}"
