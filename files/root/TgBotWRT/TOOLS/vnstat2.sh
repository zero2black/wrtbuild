#!/bin/sh

#TOKEN="6801649037:AAEXxRir02HTrZkMtnfKyf3muNn9sHcYgVc"
#CHAT_ID="-1002127430749"

# READ AUTH
if [ -f "/root/TgBotWRT/AUTH" ]; then
    BOT_TOKEN=$(head -n 1 /root/TgBotWRT/AUTH)
    CHAT_ID=$(tail -n 1 /root/TgBotWRT/AUTH)
else
    echo "Berkas AUTH tidak ditemukan."
    exit 1
fi

FILE_PATH="/etc/vnstat/vnstat.db"

# Get the file name from the path
FILE_NAME=$(basename "$FILE_PATH")

# Send document to Telegram
curl -F chat_id="$CHAT_ID" -F document=@"$FILE_PATH" https://api.telegram.org/bot$BOT_TOKEN/sendDocument
