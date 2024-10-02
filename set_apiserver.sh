#!/bin/bash
 
sudo apt-get install python3-pip
 
# FastAPI, Uvicorn, Pydantic, SQLAlchemy, pySerial, psutil 패키지 설치
echo "Installing Python packages..."
pip3 install fastapi==0.83
pip3 install uvicorn==0.16
pip3 install pydantic==1.9.2
pip3 install sqlalchemy
pip3 install pyserial psutil
 
# mpg123 및 GStreamer RTSP 서버 패키지 설치
echo "Installing system packages..."
sudo apt-get install -y mpg123
 
# 현재 사용자를 dialout 및 tty 그룹에 추가
echo "Adding user to dialout and tty groups..."
sudo usermod -a -G dialout $USER
sudo usermod -a -G tty $USER
 
# udev 규칙 파일 생성 및 설정
echo "Creating udev rule..."
sudo bash -c 'cat <<EOT > /etc/udev/rules.d/50ttyacm.rules
KERNEL=="ttyACM[0-9]*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{serial}=="208032683831", MODE="0777"
EOT'
 
# udev 서비스 리로드 및 재시작
echo "Reloading and restarting udev service..."
sudo service udev reload
sudo service udev restart
 
file_id="1q_XHVZmCkhdwsYamoPlwuzbvbd3Kk782"
file_name="/Desktop/api.tar"
wget "https://drive.google.com/uc?export=download&id=$file_id" -O ${file_name}
 
tar -xvf api.tar
 
# 서비스 유닛 파일 내용
SERVICE_CONTENT='[Unit]
Description=My Stream Service
After=multi-user.target
 
[Service]
User=jetson
Type=idle
WorkingDirectory=/home/jetson/Desktop/api/jetsonServer/app
ExecStart=/home/jetson/.local/bin/uvicorn main:app --host 192.168.33.16 --port 8888 --reload
StandardOutput=file:/home/jetson/streamlog/streamscript.log
StandardError=file:/home/jetson/streamlog/streamerror.log
Restart=always
 
[Install]
WantedBy=multi-user.target
'
 
# /etc/systemd/system/api.service 파일로 저장
echo "$SERVICE_CONTENT" | sudo tee /etc/systemd/system/api.service > /dev/null
 
 
echo "Script execution completed."
 
 
#!/bin/bash
 
set -e  # 에러가 발생하면 스크립트 종료
 
# Python 및 pip 설치 확인
if ! command -v python3 &> /dev/null; then
    echo "Python3가 설치되어 있지 않습니다. 설치 중..."
    sudo apt-get install -y python3
fi
 
if ! command -v pip3 &> /dev/null; then
    echo "pip3가 설치되어 있지 않습니다. 설치 중..."
    sudo apt-get install -y python3-pip
fi
 
# FastAPI, Uvicorn, Pydantic, SQLAlchemy, pySerial, psutil 패키지 설치
echo "Installing Python packages..."
pip3 install fastapi==0.83
pip3 install uvicorn==0.16
pip3 install pydantic==1.9.2
pip3 install sqlalchemy
pip3 install pyserial
pip3 install psutil
 
# mpg123 및 GStreamer RTSP 서버 패키지 설치
echo "Installing system packages..."
sudo apt-get install -y mpg123
 
# 현재 사용자를 dialout 및 tty 그룹에 추가
echo "Adding user to dialout and tty groups..."
sudo usermod -a -G dialout $USER
sudo usermod -a -G tty $USER
 
# udev 규칙 파일 생성 및 설정
echo "Creating udev rule..."
sudo bash -c 'cat <<EOT > /etc/udev/rules.d/50ttyacm.rules
KERNEL=="ttyACM[0-9]*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{serial}=="208032683831", MODE="0777"
EOT'
 
# udev 서비스 리로드 및 재시작
echo "Reloading and restarting udev service..."
sudo service udev reload
sudo service udev restart
 
# 파일 다운로드
file_id="1q_XHVZmCkhdwsYamoPlwuzbvbd3Kk782"
file_name="/home/jetson/Desktop/api.tar"  # 경로를 사용자 홈 디렉토리로 수정
if ! wget "https://drive.google.com/uc?export=download&id=$file_id" -O ${file_name}; then
    echo "파일 다운로드 실패"
    exit 1
fi
 
# 압축 해제
tar -xvf /home/jetson/Desktop/api.tar
 
# streamlog 디렉토리 생성
mkdir -p /home/jetson/streamlog
 
# 서비스 유닛 파일 내용
SERVICE_CONTENT='[Unit]
Description=My Stream Service
After=multi-user.target
 
[Service]
User=jetson
Type=idle
WorkingDirectory=/home/jetson/Desktop/api/jetsonServer/app
ExecStart=/home/jetson/.local/bin/uvicorn main:app --host 192.168.33.16 --port 8888 --reload
StandardOutput=file:/home/jetson/streamlog/streamscript.log
StandardError=file:/home/jetson/streamlog/streamerror.log
Restart=always
 
[Install]
WantedBy=multi-user.target
'
 
# /etc/systemd/system/api.service 파일로 저장
echo "$SERVICE_CONTENT" | sudo tee /etc/systemd/system/api.service > /dev/null
 
# 시스템 서비스 리로드 및 활성화
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload
sudo systemctl enable api.service
 
echo "Script execution completed."