#!/bin/bash
# 사용법:
# ./switch_and_test.sh <TARGET_PROFILE> [TEST_HOST]
# 예시:
#   ./switch_and_test.sh static-ip 8.8.8.8     # 외부망 테스트
#   ./switch_and_test.sh static-ip             # 현재 프로필의 게이트웨이로 테스트

PROFILE="$1"
TEST_HOST="$2"

if [ -z "$PROFILE" ]; then
    echo "⚠️ 사용법: $0 <PROFILE_NAME> [TEST_HOST]"
    exit 1
fi

echo "🔄 '$PROFILE' 프로필로 전환 중..."
nmcli connection up "$PROFILE"

# TEST_HOST 없으면 현재 프로필의 게이트웨이 추출
if [ -z "$TEST_HOST" ]; then
    TEST_HOST=$(nmcli -g IP4.GATEWAY connection show "$PROFILE")
    if [ -z "$TEST_HOST" ]; then
        echo "⚠️ 게이트웨이가 없는 프로필입니다. 테스트 호스트를 직접 지정하세요."
        exit 1
    fi
fi

echo "📡 네트워크 테스트 중... ($TEST_HOST)"
if ping -c 3 "$TEST_HOST" >/dev/null 2>&1; then
    echo "✅ 네트워크 연결 성공"
else
    echo "❌ 네트워크 연결 실패 - DHCP로 복귀"
    sudo nmcli connection up dhcp-ip
fi
