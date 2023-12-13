#!/bin/sh
no_sms=0
for i in $(seq 0 5); do
no_sms=$((no_sms+1));
#awal= echo "Row: $i _"
#akhir= echo "Row: $no_sms _"
    
    result=$(adb -s a57668797d04 shell content query --uri content://sms/inbox --sort "date DESC" | tr '\n' ' '|  awk -v awal="Row: $i _" -v akhir="Row: $no_sms _" 'match($0, awal ".*" akhir) {print substr($0, RSTART + length(awal), RLENGTH - length(awal) - length(akhir))}' |  awk -F 'body=' '{print $2}' | awk -F ', service_center=' '{print $1}')
result2=$(adb -s a57668797d04 shell content query --uri content://sms/inbox --sort "date DESC" | tr '\n' ' '|  awk -v awal="Row: $i _" -v akhir="Row: $no_sms _" 'match($0, awal ".*" akhir) {print substr($0, RSTART + length(awal), RLENGTH - length(awal) - length(akhir))}' | awk -F"[=,]" '{for(i=1; i<=NF; i++) {if ($i == " date") {print $(i+1); exit}}}')
result3=$(adb -s a57668797d04 shell content query --uri content://sms/inbox --sort "date DESC" | tr '\n' ' '|  awk -v awal="Row: $i _" -v akhir="Row: $no_sms _" 'match($0, awal ".*" akhir) {print substr($0, RSTART + length(awal), RLENGTH - length(awal) - length(akhir))}' | awk -F'address=' '{split($2, array, /[, ]/); print array[1]}')
tanggal_jam=$(date -d "@$((result2/1000))" '+%Y-%m-%d %H:%M')
        echo "SMS $no_sms"
        echo "Pengirim : $result3 ($tanggal_jam)"
        echo "$result"
        echo
done