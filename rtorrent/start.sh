#!/bin/sh

echo rigging iptables to $VPN_HOSTNAME : $VPN_PORT 
iptables -A OUTPUT -o tun0 -j ACCEPT
iptables -A OUTPUT -d $VPN_HOSTNAME -j ACCEPT
#--dport $VPN_PORT -j ACCEPT
iptables -A OUTPUT -j DROP

echo creating user
useradd --home-dir /root --uid $USERID --groups sudo $USERNAME
#adduser --disabled-password --uid $USERID $USERNAME
#usermod -u $USERID $USERNAME

# add to sudoers
#usermod -a -G sudo $USERNAME

host $VPN_HOSTNAME
echo "nordvpn stats:"
curl https://nordvpn.com/api/vpn/check/full

cd /root
sudo -u $USERNAME bash
