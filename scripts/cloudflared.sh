#!/bin/bash
# Base install.sh by Gege Desembri <https://github.com/GegeDesembri/openwrt-tools>
# Revamped installation and added various supported devices architectures (Arm, arm64, x86_generic, x86_64) by Helmi Amirudin <https://helmiau.com>

echo "Start Cloudflare Download !"
echo "Current Path: $PWD"

mkdir -p $PWD/files/usr/bin
#cd files/usr/bin || (echo "Clash core path does not exist! " && exit)

github_reponame="cloudflare/cloudflared"
path_binary="$PWD/files/usr/bin/cloudflared"


latest_binary=$(curl -s "https://api.github.com/repos/cloudflare/cloudflared/releases/latest" | jq -r .tag_name)
echo ${latest_binary}
wget -qO ${path_binary} --show-progress "https://github.com/cloudflare/cloudflared/releases/download/${latest_binary}/cloudflared-linux-amd64"
#wget -qO- "https://github.com/cloudflare/cloudflared/releases/download/2023.8.0/cloudflared-linux-arm64" > $PWD/files/usr/bin/cloudflared

echo ${path_binary}
#chmod +x $PWD/files/usr/bin/cloudflared
chmod +x ${path_binary}

mkdir -p $PWD/files/root
date=$(TZ="Asia/Jakarta" date +"%Y%m%d")
echo "AldevWRT v$date" > $PWD/files/root/aldevwrt_version
cat $PWD/files/root/aldevwrt_version
exit 0
