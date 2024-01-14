#!/bin/sh

# READ AUTH
if [ -f "/root/TgBotWRT/AUTH" ]; then
    BOT_TOKEN=$(head -n 1 /root/TgBotWRT/AUTH)
    CHAT_ID=$(tail -n 1 /root/TgBotWRT/AUTH)
else
    echo "Berkas AUTH tidak ditemukan."
    exit 1
fi

# Generate the system status report
MSG="

➤ remote usb0 = $(ip route show dev usb0 | grep default | awk '{print $3}')
➤ remote usb1 = $(ip route show dev usb1 | grep default | awk '{print $3}')

4x=$(adb -s a57668797d04 shell ip addr show | grep 'global rmnet' | grep -oE 'inet ([0-9]+\.){3}[0-9]+' | awk '{print $2}')
S8=$(adb -s ce031713f47698730c shell ip addr show | grep 'global rmnet' | grep -oE 'inet ([0-9]+\.){3}[0-9]+' | awk '{print $2}')

"

# Mengirim pesan ke akun Telegram pribadi
#URL="https://tgbotwrt.titit.tech/edy.jpg"
URL="@/root/TgBotWRT/images.jpg"
#curl -F "chat_id=$CHAT_ID" -F "caption=$MSG" -F "photo=$URL" \
#https://api.telegram.org/bot$BOT_TOKEN/sendphoto 
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$MSG"