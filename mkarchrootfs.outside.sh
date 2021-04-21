#!/bin/bash

MIRROR=https://mirrors.ustc.edu.cn/archlinux
TARBALL=${MIRROR}/iso/latest/archlinux-bootstrap-2021.04.01-x86_64.tar.gz
FILE=archlinux.tar.gz
TEMP_PATH=/tmp

# Get and extract tarball
echo "==> Acquiring and extracting tarball..."
curl ${TARBALL} -o ${TEMP_PATH}/${FILE}
tar -xzf ${TEMP_PATH}/${FILE} -C ${TEMP_PATH}/
echo "==> Preparing chroot..."
# Configure rootfs
mount --bind ${TEMP_PATH}/root.x86_64 ${TEMP_PATH}/root.x86_64
echo "Server = ${MIRROR}/\$repo/os/\$arch" >> ${TEMP_PATH}/root.x86_64/etc/pacman.d/mirrorlist
cp ./mkarchrootfs.inside.sh ${TEMP_PATH}/root.x86_64/
${TEMP_PATH}/root.x86_64/bin/arch-chroot  ${TEMP_PATH}/root.x86_64/ /mkarchrootfs.inside.sh
rm ${TEMP_PATH}/root.x86_64/mkarchrootfs.inside.sh
echo "==> Compressing archive..."
# Archive and compress rootfs
tar --numeric-owner -czf install.tar.gz -C ${TEMP_PATH}/root.x86_64/ .

EXITCODE=$?
test $EXITCODE -eq 0 && \
  echo "The built rootfs is placed in ${PWD}/install.tar.gz ." || \
  echo "Build failed. Check output for details?"; 
exit $EXITCODE