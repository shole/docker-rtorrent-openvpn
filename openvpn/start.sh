#!/bin/sh


if [ ! -z "$OPENVPN_OVPN" ]
then
	if [ -f "/ovpn/${OPENVPN_OVPN}" ]
  	then
		echo "Starting OpenVPN using config ${OPENVPN_OVPN}"
		OPENVPN_CONFIG=/ovpn/"${OPENVPN_OVPN}"
	fi
else
	echo "No VPN configuration provided. "
	exit 1
fi

# override resolv.conf
if [ "$RESOLV_OVERRIDE" != "**None**" ];
then
  echo "Overriding resolv.conf..."
  printf "$RESOLV_OVERRIDE" > /etc/resolv.conf
fi

# add OpenVPN user/pass
if [ "${OPENVPN_USERNAME}" = "**None**" ] || [ "${OPENVPN_PASSWORD}" = "**None**" ] ; then
 echo "PIA credentials not set. Exiting."
 exit 1
else
  echo "Setting OPENVPN credentials..."
  mkdir -p /config
  echo $OPENVPN_USERNAME > /config/openvpn-credentials.txt
  echo $OPENVPN_PASSWORD >> /config/openvpn-credentials.txt
  chmod 600 /config/openvpn-credentials.txt
fi

cp "$OPENVPN_CONFIG" /config/selected.ovpn

echo auth-user-pass /config/openvpn-credentials.txt >>/config/selected.ovpn
#echo script-security 2 >>/config/selected.ovpn
#echo up /etc/rtorrent/start.sh >>/config/selected.ovpn

# add transmission credentials from env vars
#echo $TRANSMISSION_RPC_USERNAME > /config/transmission-credentials.txt
#echo $TRANSMISSION_RPC_PASSWORD >> /config/transmission-credentials.txt

# Persist transmission settings for use by transmission-daemon
#dockerize -template /etc/transmission/environment-variables.tmpl:/etc/transmission/environment-variables.sh /bin/true

exec openvpn --config /config/selected.ovpn
