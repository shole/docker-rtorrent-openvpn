# rtorrent and OpenVPN
#
# Version 1.3

#FROM ubuntu:15.04
FROM debian:unstable
MAINTAINER shole

VOLUME /watch
VOLUME /download
VOLUME /root
VOLUME /ovpn

# Update packages and install software
RUN apt-get update \
    && apt-get -y install software-properties-common \
    && apt-get install -y rtorrent openvpn curl iptables host sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && curl -L https://github.com/jwilder/dockerize/releases/download/v0.0.2/dockerize-linux-amd64-v0.0.2.tar.gz | tar -C /usr/local/bin -xzv 

# Add configuration and scripts
ADD openvpn/ /etc/openvpn/
ADD rtorrent/ /etc/rtorrent/

ENV VPN_HOSTNAME=**None** \
    VPN_PORT=**None** \
    OPENVPN_USERNAME=**None** \
    OPENVPN_PASSWORD=**None** \
    OPENVPN_OVPN=**None** \
    RESOLV_OVERRIDE=**None** \
	TERM=**None** \
	USERID=**None** \
	USERNAME=**None**

# Expose port and run
CMD ["/etc/openvpn/start.sh"]
