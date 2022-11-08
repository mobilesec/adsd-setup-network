ADSD network setup
==================

This repository holds configuration files for the WiFi network tracing setup of the [Android Device Security Database](https://www.android-device.security.org) Lab at the [Institute of Networks and Security](https://jku.at/ins/) at JKU Linz. It is based on a Turris Omnia access point performing 802.1x/802.11i client specific authentication and assigning a unique (virtual) VLAN to each Android device. This allows capturing all WiFi network traffic per device, including broadcast/multicast packets and independently of MAC address randomization. 

We currently mirror all VLAN tagged packets to an [Arkime](https://arkime.com/) server for statistical analysis, but any tool capable of monitoring Ethernet packets should be useful for analysis in this setup. This is currently using L2TP because that actually worked with the standard Turris kernel and a Debian VM peer, while I couldn't manage to get a GRETAP tunnel working so far.

Note on credentials and other site-specific data
---
To make this reasonably usable, replace
* 'wifilab123' in `config/wireless` with a local PSK that devices need to connect to internal, non-VLAN-tagged network (e.g. for the access point admin interface), which is bridged to the Ethernet LAN ports
* 'testing123' in all config files and command line argyments with a randomly created password to authenticate the Radius communication
* 'client123' in `freeradius3/mods-config/files/authorize` with passwords for the actual Android clients - using the same password is ok. The user names should be unique to map to unique VLAN numbers, which is the whole point of this exercise.
* `ula_prefix` in `config/network` with a unique prefix
* potentially `wan` configuration in `config/network` if DHCP is not used upstream
* L2TP tunnel configuration for the `mirror` interface in `config/network` and `rc.local` to match the local and peer IP addresses for the specific setup
* `MAILTO` in `cron.d/local-check-connected-wifi-devices` and local mail server in `msmtprc` to receive email about device connection stats

For using a proper certificate for Radius authentication
---
Inspired by https://brainfood.xyz/post/20190518-letsencrypt-on-turris-omnia/
* Call `opkg install acme` to get the necessary scripts
* Make sure there is a publicly resolvable DNS name for your access point, with port 80 reachable from the WAN side (the firewall rule for the port on the router itself will be opened dynamically only while renewing)
* Disable sentinel/minipot (the honeypot) from catching port 80
* `mkdir mkdir -p /www/letsencrypt/.well-known/acme-challenge/`
* `echo 'alias.url += ( "/.well-known/acme-challenge/" => "/www/letsencrypt/.well-known/acme-challenge/")' > /etc/lighttpd/conf.d/05-letsencrypt.conf`
* Adapt `/etc/config/acme` with your hostname
* Change `/etc/acme/cleanup-letsencrypt.sh` to use the proper filenames with your hostname
* Execute `/etc/init.d/acme enable; /etc/init.d/acme start`
* `ln -s /etc/acme/<your-hostname>/ca.cer /etc/freeradius3/certs/ca.pem`

If something goes wrong, manually starting `/usr/lib/acme/run-acme` should give some error messages.

