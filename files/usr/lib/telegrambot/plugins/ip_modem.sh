#!/bin/sh

ip_address=$(ip -o -4 addr show usb0 | awk '{print $4}' | cut -d'/' -f1)
gateway=$(ip route show dev usb0 | grep default | awk '{print $3}')
interface="usb0"

echo "IP Address: $ip_address"
echo "Gateway: $gateway"
echo "Interface: $interface"

ip_address=$(ip -o -4 addr show usb1 | awk '{print $4}' | cut -d'/' -f1)
gateway=$(ip route show dev usb1 | grep default | awk '{print $3}')
interface="usb1"

echo "IP Address: $ip_address"
echo "Gateway: $gateway"
echo "Interface: $interface"
