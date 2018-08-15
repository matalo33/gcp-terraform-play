#!/bin/bash

set -ex

sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.conf > /dev/null
apt-get install -y iptables-persistent less traceroute