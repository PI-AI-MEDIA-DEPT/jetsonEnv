#!/bin/bash

set -e  # 에러 발생 시 종료

# IP 인자 확인
if [ -z "$1" ]; then
  echo "사용법: $0 <RTSP_IP>"
  exit 1
fi

RTSP_IP=$1

# 필요한 패키지 설치
sudo apt-get update
sudo apt-get install -y curl

# 압축 해제
cd /home/jetson/
tar -xvf /home/jetson/onvif_srvd.tar -C /home/jetson/

# 압축파일 삭제
rm /home/jetson/onvif_srvd.tar

# 실행 권한 부여
chmod +x /home/jetson/onvif_srvd

# 서비스 유닛 파일 생성
SERVICE_CONTENT="[Unit]
Description=ONVIF SERVER service (server side)
After=syslog.target
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/jetson
ExecStart=/home/jetson/onvif_srvd --ifs eth0 --name JetsonPTZ --width 1280 --height 720 --url rtsp://${RTSP_IP}:8554/mystream --type H264 --scope onvif://www.onvif.org/Profile/Streaming --ptz --no_fork --no_close
TimeoutSec=4
User=root
StandardOutput=journal
StandardError=journal
Restart=always
RestartSec=5
StartLimitBurst=0

[Install]
WantedBy=multi-user.target"

# 서비스 파일 저장
echo "$SERVICE_CONTENT" | sudo tee /etc/systemd/system/onvif.service > /dev/null

# systemd 갱신 및 서비스 실행
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload
sudo systemctl enable onvif.service
sudo systemctl restart onvif.service

echo "Script execution completed."
