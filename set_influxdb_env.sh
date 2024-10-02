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

# # 스크립트에 실행 권한 부여 (한 번만 필요)
# # chmod +x /home/jetson/jetsonEnv/set_influxdb_env.sh
#실행시 
#. set_influxdb_env.sh