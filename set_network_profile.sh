#!/bin/bash

# 실행 인자 확인
if [ -z "$1" ]; then
    echo "사용법: $0 <STATIC_IP>"
    echo "예시: $0 192.168.10.50"
    exit 1
fi

STATIC_IP=$1

# static-ip 프로파일 생성
sudo nmcli connection add type ethernet ifname eth0 con-name static-ip \
    autoconnect no \
    ipv4.addresses ${STATIC_IP}/24 \
    ipv4.method manual

# dhcp-ip 프로파일 생성
sudo nmcli connection add type ethernet ifname eth0 con-name dhcp-ip \
    ipv4.method auto \
    autoconnect no

echo "static-ip(${STATIC_IP}) 과 dhcp-ip 프로파일이 생성되었습니다."
