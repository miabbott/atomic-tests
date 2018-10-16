#!/usr/bin/env bash
set -xeuo pipefail
ISO=$1
shift
dn=$(dirname $0)

tempdir=$(mktemp -d /var/tmp/isosanity.XXXXX)
function cleanup () {
    fusermount -u ${tempdir}/mnt || true
    rm "${tempdir}" -rf
}
trap cleanup EXIT

export LIBGUESTFS_BACKEND=direct
mkdir ${tempdir}/mnt
guestmount --ro -a ${ISO} -m /dev/sda1 ${tempdir}/mnt
(cd ${tmpdir}/mnt && python -m SimpleHTTPServer 0 >../httpd.txt)
success=false
# FIXME - detect from libvirt/define our own?
hostip=192.168.122.1
for x in $(seq 30); do
    sed -e s',Serving HTTP on 0.0.0.0 port \([0-9]*\) \.\.\.,\1,' < ${tempdir}/httpd.txt > ${tempdir}/port.txt
    if cmp ${tempdir}/httpd.txt ${tempdir}/port.txt; then
        port=$(tr -d '\n' < ${tempdir}/port.txt)
        if curl "http://${hostip}:${port}"; then
            success=true
            break
        fi
    fi
    sleep 0.1
done
if !${success}; then
    echo "Failed to wait for http server"
    exit 1
fi

# --initrd-inject ${dn}/default.ks --extra-args=inst.ks=file:/default.ks
base_args="--ram 3192 --vcpus 4 --disk size=20 --os-variant rhel7 --location http://${hostip}:${port}/"

virsh -c qemu:///system undefine isosanity-efi || true
virt-install ${base_args} --name isosanity-efi --boot uefi
virsh -c qemu:///system undefine isosanity-bios || true
virt-install ${base_args} --name isosanity-bios
