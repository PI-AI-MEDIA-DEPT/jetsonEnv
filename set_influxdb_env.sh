#!/bin/bash

# InfluxDB 환경 변수 설정
export INFLUX_TOKEN=nxft2SEGZrEH2-jwDIea6tDSiX6TqHn50u0kOcDqSRnUdnK25VYauC0buWdwh-UFq6dgeb7qf3pMyKg6sbf6zg==
export INFLUX_BUCKET=AI
export INFLUX_ORG=paimedialab
export INFLUX_HOST=192.168.33.5

# 설정된 환경 변수 확인
echo "INFLUX_TOKEN: $INFLUX_TOKEN"
echo "INFLUX_BUCKET: $INFLUX_BUCKET"
echo "INFLUX_HOST: $INFLUX_HOST"
echo "INFLUX_ORG: $INFLUX_ORG"

# 스크립트에 실행 권한 부여
chmod +x set_influxdb_env.sh

# 스크립트 실행
./set_influxdb_env.sh

# systemd 서비스 파일 생성
sudo bash -c 'cat << EOF > /etc/systemd/system/set_influxdb_env.service
[Unit]
Description=Set InfluxDB Environment Variables

[Service]
ExecStart=/path/to/set_influxdb_env.sh
Type=oneshot

[Install]
WantedBy=multi-user.target
EOF'

# systemd 서비스 재로드 및 활성화
sudo systemctl daemon-reload
sudo systemctl enable set_influxdb_env.service