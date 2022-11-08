#!/bin/sh
uci set firewall.letsencrypt.enabled=1
uci commit firewall
/etc/init.d/firewall reload

