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


#chmod +x set_influxdb_env.sh
#./set_influxdb_env.sh
# source ./set_influxdb_env.sh

#sudo nano /etc/systemd/system/set_influxdb_env.service

#creat ini file

# [Unit]
# Description=Set InfluxDB Environment Variables

# [Service]
# ExecStart=/path/to/set_influxdb_env.sh
# Type=oneshot

# [Install]
# WantedBy=multi-user.target

# sudo systemctl daemon-reload
# sudo systemctl enable set_influxdb_env.service