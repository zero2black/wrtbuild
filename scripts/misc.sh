#!/bin/bash

echo "Start Downloading Misc files and setup configuration!"
echo "Current Path: $PWD"

#setup custom setting for openwrt and immortalwrt
#sed -i "s/Ouc3kNF6/$DATE/g" files/etc/uci-defaults/99-init-settings.sh


# custom script files urls
echo "Downloading custom script" 
#speedtest="https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-$ARCH_2.tgz"
#sync_time="https://raw.githubusercontent.com/frizkyiman/auto-sync-time/main/sbin/sync_time.sh"
#clock="https://raw.githubusercontent.com/frizkyiman/auto-sync-time/main/usr/bin/clock"
repair_ro="https://raw.githubusercontent.com/frizkyiman/fix-read-only/main/install2.sh"
#mount_hdd="https://raw.githubusercontent.com/frizkyiman/auto-mount-hdd/main/mount_hdd"

#if wget --no-check-certificate -nv -P files "$speedtest"; then
#   tar -zxf files/ookla-speedtest-1.2.0-linux-"$ARCH_2".tgz -C files/usr/bin
#   rm files/ookla-speedtest-1.2.0-linux-"$ARCH_2".tgz && rm files/usr/bin/speedtest.md
#else
#    echo "Failed to download and extract speedtest files!"
#fi

#wget --no-check-certificate -nv -P files/sbin "$sync_time"
#wget --no-check-certificate -nv -P files/usr/bin "$clock"
wget --no-check-certificate -nv -P files/root "$repair_ro"
#wget --no-check-certificate -nv -P files/usr/bin "$mount_hdd"

echo "All custom configuration setup completed!"
