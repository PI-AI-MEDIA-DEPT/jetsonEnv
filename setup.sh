#!/bin/bash

echo "yahboom" sudo -S apt update -y
sudo apt install nano

sudo apt autoremove -y
sudo apt clean

sudo apt remove thunderbird libreoffice-* -y
sudo rm -rf /usr/local/cuda/samples \
/usr/src/cudnn_samples_* \
/usr/src/tensorrt/data \
/usr/src/tensorrt/samples \
/usr/share/visionworks* ~/VisionWorks-SFM*Samples \
/opt/nvidia/deepstream/deepstream*/samples

sudo apt-get update && sudo apt-get install cuda-toolkit-10-2 -y
export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64:$LD_LIBRARY_PATH
echo "yahboom" sudo -S apt install nvidia-container-csv-cuda
sudo apt install nvidia-container-csv-cudnn -y
#!/bin/bash


# MediaMTX 다운로드
wget https://github.com/bluenviron/mediamtx/releases/download/v1.9.1/mediamtx_v1.9.1_linux_arm64v8.tar.gz

# 압축 해제
tar -xzf mediamtx_v1.9.1_linux_arm64v8.tar.gz

# 압축 해제가 성공했는지 확인
if [ $? -ne 0 ]; then
  echo "압축 해제에 실패했습니다."
  exit 1
fi

# 실행 파일 및 설정 파일을 이동
sudo mv mediamtx /usr/local/bin/
sudo mv mediamtx.yml /usr/local/etc/

# 파일이 제대로 이동되었는지 확인
if [ ! -f /usr/local/bin/mediamtx ]; then
  echo "mediamtx 실행 파일을 찾을 수 없습니다."
  exit 1
fi

if [ ! -f /usr/local/etc/mediamtx.yml ]; then
  echo "mediamtx 설정 파일을 찾을 수 없습니다."
  exit 1
fi

# systemd 서비스 파일 생성
sudo tee /etc/systemd/system/mediamtx.service >/dev/null << EOF
[Unit]
Description=MediaMTX Service
Wants=network.target
After=network.target

[Service]
ExecStart=/usr/local/bin/mediamtx /usr/local/etc/mediamtx.yml
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# systemd 설정 다시 로드 및 서비스 등록
sudo systemctl daemon-reload
sudo systemctl enable mediamtx

# MediaMTX 서비스 시작
sudo systemctl start mediamtx

# 상태 확인
sudo systemctl status mediamtx


git clone https://github.com/PI-AI-MEDIA-DEPT/jetsonEnv.git
cd /home/jetson/jetsonEnv

# chmod +x set_install_IMX.sh
chmod +x set_apiserver.sh
chmod +x set_influxdb_env.sh

. install_full.sh -m imx477

cd /home/jetson/jetsonEnv

. set_apiserver.sh

cd /home/jetson/jetsonEnv

. set_influxdb_env.sh



docker run --restart always -it --name edge --runtime nvidia --device /dev/video0 -e INFLUX_TOKEN=$INFLUX_TOKEN -e INFLUX_BUCKET=$INFLUX_BUCKET -e INFLUX_ORG=$INFLUX_ORG -e INFLUX_HOST=$INFLUX_HOST --env HOST_IP=$(hostname -I | awk '{print $1}') --network host --volume /tmp/argus_socket:/tmp/argus_socket -v /home/jetson/jetsonEnv:/loc -w /loc --privileged aimedia/jetson-gst-yolov8:0.5 python3 test.py