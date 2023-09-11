#!/bin/bash
comp_image=$1
unxz $comp_image
image=${comp_image%.*}
echo $image
sudo losetup -P /dev/loop0 $image
sudo mount /dev/loop0p1 /media
sudo cp ../kernel/uImage ../kernel/exynos4412-fs4412.dtb /media
sudo umount /media
sudo losetup -d /dev/loop0
xz $image
ls -lh $comp_image

