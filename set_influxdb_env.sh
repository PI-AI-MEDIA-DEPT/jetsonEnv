#!/bin/bash

# InfluxDB 환경 변수 설정
INFLUX_TOKEN=nxft2SEGZrEH2-jwDIea6tDSiX6TqHn50u0kOcDqSRnUdnK25VYauC0buWdwh-UFq6dgeb7qf3pMyKg6sbf6zg==
INFLUX_BUCKET=AI
INFLUX_ORG=paimedialab
INFLUX_HOST=http://192.168.33.5:8086

# 환경 변수를 /etc/environment에 저장
echo "INFLUX_TOKEN=$INFLUX_TOKEN" | sudo tee -a /etc/environment
echo "INFLUX_BUCKET=$INFLUX_BUCKET" | sudo tee -a /etc/environment
echo "INFLUX_ORG=$INFLUX_ORG" | sudo tee -a /etc/environment
echo "INFLUX_HOST=$INFLUX_HOST" | sudo tee -a /etc/environment