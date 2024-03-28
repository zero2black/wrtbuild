#!/bin/bash

echo "Start Clash Core Download !"
echo "Current Path: $PWD"

echo "Start YACD Download !"

yacd_dir="${1:-files/usr/share/openclash/ui}"
yacd="https://github.com/taamarin/yacd-meta/archive/gh-pages.zip"
mkdir -p $yacd_dir
if wget --no-check-certificate -nv $yacd -O $yacd_dir/yacd.zip; then
   unzip -qq $yacd_dir/yacd.zip -d $yacd_dir && rm $yacd_dir/yacd.zip
   if mv $yacd_dir/yacd-meta-gh-pages $yacd_dir/yacd.new; then 
     echo "YACD Dashboard download successfully."
   fi
else
   echo "Failed to download YACD Dashboard"
fi

#mkdir -p files/etc/openclash/core
#cd files/etc/openclash/core || (echo "Clash core path does not exist! " && exit)
#wget https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-linux-amd64.tar.gz | tar xOvz > files/etc/openclash/core/clash2
# wget https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-amd64.tar.gz | tar xOvz > files/temp/clash_meta
# wget https://raw.githubusercontent.com/vernesong/OpenClash/core/master/premium/clash-linux-amd64.tar.gz
#tar -zxvf clash-linux-amd64.tar.gz
#rm -rf clash-linux-amd64.tar.gz

#cd ..
#wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
#wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat

# clash-core
mkdir -p files/etc/openclash/core
#CLASH_DEV_URL=$(curl -fsSL https://api.github.com/repos/vernesong/OpenClash/releases/tags/Clash | grep download_url | grep clash-linux-amd64 | awk -F '"' '{print $4}')
#CLASH_TUN_URL=$(curl -sL http://api.github.com/repos/Dreamacro/clash/releases/tags/premium | grep download_url | grep clash-linux-amd64 | awk -F '"' '{print $4}')
#CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-amd64.tar.gz"
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/18rudi/v2ray-rules-dat/releases/latest/download/geosite.dat"
#wget -qO- $CLASH_DEV_URL | tar xOvz > files/etc/openclash/core/clash
#wget -qO- $CLASH_TUN_URL | gunzip -c > files/etc/openclash/core/clash_tun
#wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
chmod +x files/etc/openclash/core/clash*



exit 0
