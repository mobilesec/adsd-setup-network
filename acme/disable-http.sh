#!/bin/sh
uci set firewall.letsencrypt.enabled=0
uci commit firewall
/etc/init.d/firewall reload

