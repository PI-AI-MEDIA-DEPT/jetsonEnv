#!/bin/bash

# 서비스 파일 경로
SERVICE_FILE_PATH="/etc/systemd/system/set_influxdb_env.service"

# 서비스 파일 작성
echo "[Unit]
Description=Set InfluxDB Environment Variables

[Service]
Type=oneshot
ExecStart=/bin/bash -c '. /home/jetson/jetsonEnv/set_influxdb_env.sh'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE_PATH > /dev/null

# 서비스 파일의 권한 설정
sudo chmod 644 $SERVICE_FILE_PATH

# systemd 서비스 활성화 및 시작
sudo systemctl enable set_influxdb_env.service
sudo systemctl start set_influxdb_env.service

# 상태 확인
sudo systemctl status set_influxdb_env.service

#chmod +x register_influxdb_service.sh
#./register_influxdb_service.sh