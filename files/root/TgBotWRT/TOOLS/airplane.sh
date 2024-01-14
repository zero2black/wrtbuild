#!/bin/sh

# READ AUTH
if [ -f "/root/TgBotWRT/AUTH" ]; then
    BOT_TOKEN=$(head -n 1 /root/TgBotWRT/AUTH)
    CHAT_ID=$(tail -n 1 /root/TgBotWRT/AUTH)
else
    echo "Berkas AUTH tidak ditemukan."
    exit 1
fi


modem=$1

if [ "$modem" = "s8" ]; then
    device=ce031713f47698730c
else
    device=a57668797d04
fi


adb -s $device shell cmd connectivity airplane-mode enable
sleep 2
adb -s $device shell cmd connectivity airplane-mode disable

# Function to check if IP is not empty
check_ip() {
    if [ -n "$1" ]; then
        return 0  # IP is not empty
    else
        return 1  # IP is empty
    fi
}

while true; do
    # Replace this command with your actual command to get the IP address
    current_ip=$(adb -s $device shell ip addr show | grep 'global rmnet'  | grep -oE 'inet ([0-9]+\.){3}[0-9]+' | awk '{print $2}')

    # Check if the IP is not empty
    if check_ip "$current_ip"; then
        # Run your command when the IP is not empty
        abc
        break  # Break out of the loop after running the command
    fi

    # Sleep for a certain duration before checking again
    sleep 2
done

# Generate the system status report
MSG="

➤ IP = $(adb -s $device shell ip addr show | grep 'global rmnet'  | grep -oE 'inet ([0-9]+\.){3}[0-9]+' | awk '{print $2}')

"

# Mengirim pesan ke akun Telegram pribadi
#URL="https://tgbotwrt.titit.tech/edy.jpg"
#URL="@/root/TgBotWRT/images.jpg"
#curl -F "chat_id=$CHAT_ID" -F "caption=$MSG" -F "photo=$URL" \
#https://api.telegram.org/bot$BOT_TOKEN/sendphoto
#sleep 3
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$MSG"