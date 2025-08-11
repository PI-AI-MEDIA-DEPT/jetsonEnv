#!/bin/bash

# 사용법 안내
if [ -z "$1" ]; then
    echo "사용법: $0 <STATIC_IP> [GATEWAY]"
    echo "예시1: $0 192.168.10.50 192.168.10.1"
    echo "예시2: $0 192.168.10.50   # 게이트웨이 생략 시 DHCP에서 자동 추출"
    exit 1
fi

STATIC_IP=$1
GATEWAY=$2

# 게이트웨이 인자 없으면 DHCP에서 가져오기
if [ -z "$GATEWAY" ]; then
    echo "[1] 현재 DHCP 연결에서 게이트웨이 확인 중..."
    GATEWAY=$(ip route | grep default | awk '{print $3}')
    if [ -z "$GATEWAY" ]; then
        echo "❌ 게이트웨이를 찾을 수 없습니다. 직접 입력하거나 DHCP로 연결 상태를 확인하세요."
        exit 1
    fi
    echo "→ 자동으로 게이트웨이 설정: $GATEWAY"
else
    echo "→ 입력받은 게이트웨이 사용: $GATEWAY"
fi

# static-ip 프로파일 생성
sudo nmcli connection add type ethernet ifname eth0 con-name static-ip \
    autoconnect no \
    ipv4.addresses ${STATIC_IP}/24 \
    ipv4.gateway ${GATEWAY} \
    ipv4.method manual

# dhcp-ip 프로파일 생성
sudo nmcli connection add type ethernet ifname eth0 con-name dhcp-ip \
    ipv4.method auto \
    autoconnect no

echo "✅ static-ip(${STATIC_IP}, gateway: ${GATEWAY}) 와 dhcp-ip 프로파일 생성 완료"
