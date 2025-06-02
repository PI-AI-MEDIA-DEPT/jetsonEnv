#!/bin/bash
 
set -e  # 에러가 발생하면 스크립트 종료

# 파일 다운로드
file_id="1D16aBVE9lyI-FiqvpNkazCWYt4HaDFCN"
file_name="/home/jetson/wsdd.tar"  # 경로를 사용자 홈 디렉토리로 수정
if ! wget "https://drive.google.com/uc?export=download&id=$file_id" -O ${file_name}; then
    echo "파일 다운로드 실패"
    exit 1
fi

# 압축 해제
cd /home/jetson/
tar -xvf /home/jetson/wsdd.tar -C /home/jetson/

# 삭제
rm /home/jetson/wsdd.tar

# 권한 변경
cd /home/jetson/wsdd/
chmod +x start-wsdd.sh

# 서비스 유닛 파일 내용
SERVICE_CONTENT='[Unit]
Description=ONVIF WS-Discovery service (server side)
After=syslog.target
After=network.target

[Service]
Type=forking
WorkingDirectory=/home/jetson/wsdd
ExecStart=/home/jetson/wsdd/start-wsdd.sh
TimeoutSec=4
User=root
StandardOutput=journal
StandardError=journal
Restart=always
RestartSec=5
StartLimitBurst=0

[Install]
WantedBy=multi-user.target'

# /etc/systemd/system/wsdd.service 파일로 저장
echo "$SERVICE_CONTENT" | sudo tee /etc/systemd/system/wsdd.service > /dev/null
 
# 시스템 서비스 리로드 및 활성화
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload
sudo systemctl enable wsdd.service
sudo systemctl start wsdd.service
 
echo "Script execution completed."
