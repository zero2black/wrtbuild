#!/bin/sh
modem=$1

if [ "$modem" = "s8" ]; then
    device=ce031713f47698730c
else
    device=a57668797d04
fi

# Ganti TOKEN_BOT dengan token bot Anda
TOKEN_BOT="6801649037:AAEXxRir02HTrZkMtnfKyf3muNn9sHcYgVc"
CHAT_ID="555502014"

# Pesan yang ingin Anda kirim
# MESSAGE="Hello, ini pesan dari skrip Bash!"

no_sms=0
for i in $(seq 0 4); do
no_sms=$((no_sms+1));
#awal= echo "Row: $i _"
#akhir= echo "Row: $no_sms _"

raw_data=$(adb -s $device shell content query --uri content://sms/inbox --sort "date DESC" | tr '\n' ' '|  awk -v awal="Row: $i _" -v akhir="Row: $no_sms _" 'match($0, awal ".*" akhir) {print substr($0, RSTART + length(awal), RLENGTH - length(awal) - length(akhir))}')

result=$(echo "$raw_data" | awk -F 'body=' '{print $2}' | awk -F ', service_center=' '{print $1}')

result2=$(echo "$raw_data"  | awk -F"[=,]" '{for(i=1; i<=NF; i++) {if ($i == " date") {print $(i+1); exit}}}')

result3=$(echo "$raw_data"  | awk -F'address=' '{split($2, array, /[, ]/); print array[1]}')

tanggal_jam=$(date -d "@$((result2/1000))" '+%Y-%m-%d %H:%M')
        echo "SMS $no_sms"
quote_text="This is the
 quoted text."

#sms="SMS $no_sms 
sms="Pengirim: $result3 ($tanggal_jam)"

echo $sms
echo $result
echo ""
        #echo $raw_data
#curl -s -X POST "https://api.telegram.org/bot$TOKEN_BOT/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$sms"

done