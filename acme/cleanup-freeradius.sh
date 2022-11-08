#!/bin/sh
/etc/acme/disable-http.sh

cat /etc/acme/ads-ap.ins.jku.at/ads-ap.ins.jku.at.cer /etc/acme/ads-ap.ins.jku.at/ads-ap.ins.jku.at.key > /etc/freeradius3/certs/server.pem
/etc/init.d/radiusd restart
