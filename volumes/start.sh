#!/bin/sh

if [ ! -f /etc/openvpn/keys/ta.key ]; then
    cd /etc/openvpn/keys/
    openvpn --genkey --secret ta.key
fi

if ! `iptables -C INPUT -p UDP --dport 1194 -j ACCEPT`; then
    iptables -A INPUT -p UDP --dport 1194 -j ACCEPT
fi

if ! `iptables -C INPUT -s 10.15.0.0/24 -j ACCEPT`; then
    iptables -A INPUT -s 10.15.0.0/24 -j ACCEPT
fi

if ! `iptables -C FORWARD -s 10.15.0.0/24 -j ACCEPT`; then
    iptables -A FORWARD -s 10.15.0.0/24 -j ACCEPT
fi

if ! `iptables -C FORWARD -d 10.15.0.0/24 -j ACCEPT`; then
    iptables -A FORWARD -d 10.15.0.0/24 -j ACCEPT
fi

if ! `iptables -t nat -C POSTROUTING -s 10.15.0.0/24 -j MASQUERADE`; then
    iptables -t nat -A POSTROUTING -s 10.15.0.0/24 -j MASQUERADE
fi

exec openvpn --config /etc/openvpn/server.conf
