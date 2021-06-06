#!/bin/bash
numdev=`ip link | egrep "wlan1\.\d+: <.*UP.*>" | wc -l`
expected=20

if [ $numdev -lt $expected ]; then
	echo "Only $numdev devices connected through WiFi at the moment, expected $expected:"
	echo
	ip link | egrep "wlan"
	exit 1
else
	echo "Expected number of devices ($expected) seems connected to WiFi"
	exit 0
fi

