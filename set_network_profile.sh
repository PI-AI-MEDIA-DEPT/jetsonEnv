#!/bin/bash

# 사용법 안내
if [ -z "$1" ]; then
    echo "사용법: $0 <STATIC_IP/CIDR> [GATEWAY] [DNS]"
    echo "예시1: $0 10.10.30.50/24 10.10.30.1 8.8.8.8,1.1.1.1"
    echo "예시2: $0 10.3.2.105/8 10.3.2.1"
    exit 1
fi

STATIC_IP_CIDR=$1
GATEWAY=$2
DNS=$3

# 게이트웨이 자동 추출
if [ -z "$GATEWAY" ]; then
    echo "[1] DHCP에서 게이트웨이 가져오는 중..."
    GATEWAY=$(ip route | grep default | awk '{print $3}')
    if [ -z "$GATEWAY" ]; then
        echo "❌ 게이트웨이를 찾을 수 없습니다. 직접 입력하세요."
        exit 1
    fi
    echo "→ 게이트웨이 자동 설정: $GATEWAY"
else
    echo "→ 입력받은 게이트웨이 사용: $GATEWAY"
fi

# DNS 자동 설정
if [ -z "$DNS" ]; then
    DNS="8.8.8.8,1.1.1.1"
    echo "→ 기본 DNS 사용: $DNS"
else
    echo "→ 입력받은 DNS 사용: $DNS"
fi

# 기존 연결 삭제
sudo nmcli connection delete static-ip >/dev/null 2>&1
sudo nmcli connection delete dhcp-ip >/dev/null 2>&1

# static-ip 프로파일 생성
sudo nmcli connection add type ethernet ifname eth0 con-name static-ip \
    autoconnect no \
    ipv4.addresses ${STATIC_IP_CIDR} \
    ipv4.gateway ${GATEWAY} \
    ipv4.dns "${DNS}" \
    ipv4.route-metric 10 \
    ipv4.method manual

# dhcp-ip 프로파일 생성
sudo nmcli connection add type ethernet ifname eth0 con-name dhcp-ip \
    ipv4.method auto \
    autoconnect no

# 다른 활성화된 연결 비활성화 (eth0 제외)
for CONN in $(nmcli -t -f NAME,DEVICE connection show --active | grep -v ":eth0" | cut -d: -f1); do
    echo "🔻 다른 연결 비활성화: $CONN"
    sudo nmcli connection down "$CONN"
done

# default route 강제 지정
sudo ip route del default 2>/dev/null
sudo ip route add default via ${GATEWAY} dev eth0

echo "✅ static-ip(${STATIC_IP_CIDR}, GW: ${GATEWAY}, DNS: ${DNS}) 과 dhcp-ip 생성 완료"
