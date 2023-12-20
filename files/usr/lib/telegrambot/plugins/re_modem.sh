#!/bin/bash
modem=$1

if $modem = "s8" then
device = ce031713f47698730c
else
device = a57668797d04
fi

adb -s $device shell cmd connectivity airplane-mode enable
sleep 3
adb -s $device shell cmd connectivity airplane-mode disable
echo "refresh network modem $1 berhasil"

