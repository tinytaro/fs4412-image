#!/bin/sh
growpart /dev/mmcblk0 2
resize2fs /dev/mmcblk0p2
# generate unique machine id
rm -f /etc/machine-id /var/lib/dbus/machine-id
dbus-uuidgen --ensure=/etc/machine-id
dbus-uuidgen --ensure
# halt the system
shutdown -H now

