#!/bin/bash

echo "Start Builder Patch !"
echo "Current Path: $PWD"

cd $GITHUB_WORKSPACE/$VENDOR-imagebuilder-$VERSION-x86-64.Linux-x86_64 || exit

# Remove redundant default packages
sed -i "/luci-app-cpufreq/d" include/target.mk

# Force opkg to overwrite files
sed -i "s/install \$(BUILD_PACKAGES)/install \$(BUILD_PACKAGES) --force-overwrite/" Makefile

#sed -i "s/option check_signature/# option check_signature/" repositories.conf
#echo "src/gz fantastic_packages_luci https://fantastic-packages.github.io/packages/releases/22.03/packages/x86_64/luci" >> repositories.conf

# Not generate ISO images for it is too big
sed -i "s/CONFIG_ISO_IMAGES=y/# CONFIG_ISO_IMAGES is not set/" .config
# Root filesystem archives
        sed -i "s|CONFIG_TARGET_ROOTFS_CPIOGZ=.*|# CONFIG_TARGET_ROOTFS_CPIOGZ is not set|g" .config
        # Root filesystem images
        sed -i "s|CONFIG_TARGET_ROOTFS_EXT4FS=.*|# CONFIG_TARGET_ROOTFS_EXT4FS is not set|g" .config
        sed -i "s|CONFIG_TARGET_ROOTFS_SQUASHFS=.*|# CONFIG_TARGET_ROOTFS_SQUASHFS is not set|g" .config
        sed -i "s|CONFIG_TARGET_IMAGES_GZIP=.*|# CONFIG_TARGET_IMAGES_GZIP is not set|g" .config
    

# Not generate VHDX images
sed -i "s/CONFIG_VHDX_IMAGES=y/# CONFIG_VHDX_IMAGES is not set/" .config
sed -i "s/CONFIG_VDI_IMAGES=y/# CONFIG_VDI_IMAGES is not set/" .config
sed -i "s/CONFIG_VMDK_IMAGES=y/# CONFIG_VMDK_IMAGES is not set/" .config
sed -i "s/CONFIG_QCOW2_IMAGES=y/# CONFIG_QCOW2_IMAGES is not set/" .config

sed -i "s/CONFIG_LUCI_LANG_zh_Hans=.*/# CONFIG_LUCI_LANG_zh_Hans is not set/" .config
sed -i "s/CONFIG_PACKAGE_luci-i18n-base-zh-cn=.*/# CONFIG_PACKAGE_luci-i18n-base-zh-cn is not set/" .config
sed -i "s/CONFIG_PACKAGE_luci-i18n-firewall-zh-cn=.*/# CONFIG_PACKAGE_luci-i18n-firewall-zh-cn is not set/" .config
sed -i "s/CONFIG_PACKAGE_luci-i18n-opkg-zh-cn=.*/# CONFIG_PACKAGE_luci-i18n-opkg-zh-cn is not set/" .config
sed -i "s/CONFIG_PACKAGE_luci-i18n-attendedsysupgrade-zh-cn=.*/# CONFIG_PACKAGE_luci-i18n-attendedsysupgrade-zh-cn is not set/" .config
sed -i "s/CONFIG_PACKAGE_default-settings-chn=.*/# CONFIG_PACKAGE_default-settings-chn is not set/" .config
sed -i "s/CONFIG_DEFAULT_default-settings-chn=.*/# CONFIG_DEFAULT_default-settings-chn is not set/" .config
sed -i "s/CONFIG_MODULE_DEFAULT_default-settings-chn=.*/# CONFIG_MODULE_DEFAULT_default-settings-chn is not set/" .config


# modify partition size
sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=128/" .config
#sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=2048/" .config
sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=1024/" .config
ls
cat .config
#rm -rf files/etc/uci-defaults/99-default-settings-chinese

# speedtest
mkdir -p files/bin
wget -qO- https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz | tar xOvz > files/bin/speedtest
chmod +x files/bin/speedtest

#neofetch
mkdir -p files/usr/bin

wget --no-check-certificate -O files/usr/bin/dokodok "https://raw.githubusercontent.com/18rudi/es_teh/master/dokodok"
chmod +x files/usr/bin/dokodok

wget --no-check-certificate -O files/usr/bin/neofetch "https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch"
chmod +x files/usr/bin/neofetch
