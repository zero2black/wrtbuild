#!/bin/sh

# READ AUTH
if [ -f "/root/TgBotWRT/AUTH" ]; then
    BOT_TOKEN=$(head -n 1 /root/TgBotWRT/AUTH)
    CHAT_ID=$(tail -n 1 /root/TgBotWRT/AUTH)
else
    echo "Berkas AUTH tidak ditemukan."
    exit 1
fi


#f [ "$modem" = "s8" ]; then
#    device=ce031713f47698730c
#else
#    device=a57668797d04
#fi

if [ -f "/root/smsid_s8" ]; then
    sms_id=$(head -n 1 /root/smsid_s8)
else
    echo "Berkas smsid not found"
    
fi

cek_id=$(adb -s ce031713f47698730c shell content query --uri content://sms/inbox --sort "date DESC" | grep 'Row: 0' | awk '{print $3}')
if [ "$sms_id" = "$cek_id" ]; then
echo "sudah update"
cat /root/sms_s8

else

echo "sms update"
echo $cek_id > /root/smsid_s8

sms_raw=$(adb -s ce031713f47698730c shell content query --uri content://sms/inbox --sort "date DESC" | tr '\r\n' ' ' | sed 's/Row: /\nSMS_/g')

sms_raw_wip=$(echo "$sms_raw" |sed 's/ _id=.*address=/\, pengirim /'|sed 's/, person=.*date=/\ ,tanggal /'|sed 's/, date_sent=.*, body=/\ pesan_sms=/'|sed 's/, service_center=.*//')

rm /root/sms_s8
no_sms=0
 
for i in $(seq 0 4); do
no_sms=$((no_sms+1));

tanggal_raw=$(echo  "$sms_raw_wip" | grep 'SMS_'$i',' | awk '{print $5}')

tanggal_jam=$(date -d "@$((tanggal_raw/1000))" '+%Y-%m-%d %H:%M')
pengirim=$(echo  "$sms_raw_wip" | grep 'SMS_'$i',' | awk '{print $3}')
sms=$(echo "$sms_raw_wip" | grep 'SMS_'$i',' |sed 's/.*sms=//')
echo "sms $no_sms : $pengirim ($tanggal_jam)
$sms
" >> /root/sms_s8
done


fi

sm_s=$(cat /root/sms_s8)
message=$(printf %s "$sm_s" | jq -s -R -r @uri)

#done

# Generate the system status report
MSG="
➤ ⏰ 𝘿𝙖𝙩𝙚: $(date +"%d %b %Y | %H:%M")

 $message
"

# Mengirim pesan ke akun Telegram pribadi
#URL="https://tgbotwrt.titit.tech/edy.jpg"
URL="@/root/TgBotWRT/images.jpg"
#curl -F "chat_id=$CHAT_ID" -F "caption=$MSG" -F "photo=$URL" \
#https://api.telegram.org/bot$BOT_TOKEN/sendphoto
# Kirim pesan notifikasi ke bot Telegram
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$MSG"