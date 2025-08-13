#!/bin/bash
# 사용법: ./create_profiles.sh <STATIC_IP> <GATEWAY> <DNS> [PREFIX]
# 예시: ./create_profiles.sh 10.10.30.50 10.10.30.1 8.8.8.8 24

STATIC_IP="$1"
PREFIX="${2:-24}"  # 기본은 /24
GATEWAY="$3"
DNS="$4"

# static-ip 프로필 삭제 후 생성
nmcli connection delete static-ip >/dev/null 2>&1
nmcli connection add type ethernet con-name static-ip ifname "$(ip route | grep '^default' | awk '{print $5}')" \
    ipv4.addresses "$STATIC_IP/$PREFIX" \
    ipv4.gateway "$GATEWAY" \
    ipv4.dns "$DNS" \
    ipv4.method manual

# dhcp-ip 프로필 없으면 생성
if ! nmcli connection show | grep -q "^dhcp-ip"; then
    nmcli connection add type ethernet con-name dhcp-ip ifname "$(ip route | grep '^default' | awk '{print $5}')" \
        ipv4.method auto
    echo "✅ DHCP 프로필 생성 완료"
else
    echo "ℹ️ DHCP 프로필은 이미 존재"
fi

echo "✅ 프로필 생성 완료"
