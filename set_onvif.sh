#!/bin/bash
 
set -e  # 에러가 발생하면 스크립트 종료


# 압축 해제
cd /home/jetson/
tar -xvf /home/jetson/onvif_srvd.tar -C /home/jetson/

# 삭제
rm /home/jetson/onvif_srvd.tar

# 권한 변경
chmod +x onvif_srvd

# 서비스 유닛 파일 내용
SERVICE_CONTENT='[Unit]
Description=ONVIF SERVER service (server side)
After=syslog.target
After=network.target

[Service]
Type= simple
WorkingDirectory=/home/jetson
ExecStart=/home/jetson/onvif_srvd --ifs eth0 --name JetsonPTZ --width 1280 --height 720 --url rtsp://%:8554/mystream --type H264 --scope onvif://www.onvif.org/Profile/Streaming --ptz --no_fork --no_close
TimeoutSec=4
User=root
StandardOutput=journal
StandardError=journal
Restart=always
RestartSec=5
StartLimitBurst=0

[Install]
WantedBy=multi-user.target'

# /etc/systemd/system/onvif.service 파일로 저장
echo "$SERVICE_CONTENT" | sudo tee /etc/systemd/system/onvif.service > /dev/null
 
# 시스템 서비스 리로드 및 활성화
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload
sudo systemctl enable onvif.service
sudo systemctl start onvif.service
 
echo "Script execution completed."
