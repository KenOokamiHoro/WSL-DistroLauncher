#!/bin/bash

echo "==> [rootfs] Initializing Pacman Keyring..."
pacman-key --init
pacman-key --populate archlinux
echo "==> [rootfs] Installing and updating base packages..."
pacman -Syu base base-devel nano --needed --noconfirm
echo "==> [rootfs] Updating locale..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
locale-gen
echo "\%wheel    ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/10_all-wheels