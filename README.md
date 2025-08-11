# MK3 Check List



## IP Setting
  ### 공통사항
  네트워크 프로필 생성
  
    nmcli connection show
    nmcli device status

    . set_network_profile #원하는 고정 IP #게이트웨이
    
  ### 고정 아이피 세팅
  - ```
    sudo nmcli connection modify dhcp-ip connection.autoconnect no
    sudo nmcli connection modify static-ip connection.autoconnect yes
    sudo reboot
    ```
  
  ### 고정 아이피 변경
  - ```
    sudo nmcli connection modify static-ip ipv4.addresses 192.168.1.102/24
    sudo reboot
    opt1. sudo nmcli connection modify static-ip ipv4.gateway 192.168.1.1
    opt2. sudo nmcli connection modify static-ip ipv4.dns "8.8.8.8 1.1.1.1"
    ip addr show eth0
    ```

  ### DHCP 세팅
  - ```
    sudo nmcli connection modify static-ip connection.autoconnect no
    sudo nmcli connection modify dhcp-ip connection.autoconnect yes
    sudo reboot
    ```

  ### sunba camera ip setting
  - vms 통해서 변경

## Camera Check

  ### docker 실행시
  - mediamtx service check
   ```
   sudo systemctl status mediamtx.service
   ```
  - camera fastapi service check
   ```
    sudo systemctl status api.service
   ```
  - docker check
   ```
    docker ps
   ```
  - WebRTC 체크
    -> http://{{IP}}:8889/mystream
  - NVR 체크
    -> NVR 화면에서 카메라 나오는지 확인 
    
  ### stream으로 실행시
  - 기존 도커 삭제
   ```
    docker rm -f edge
   ```
  - mediamtx 서비스 종료
   ```
    sudo systemctl stop mediamtx.service
    sudo systemctl disable mediamtx.service
   ```
  - main.py 변경
  - api.service 재시작
   ```
    sudo systemctl restart api.service
   ```
  - NVR 체크
    -> NVR 화면에서 카메라 나오는지 확인 

## Focus 체크
- NVR 또는 Webrtc로 화면 작동 확인
- http://{{IP}}:7777/setFocus/{{value}}
  0 ~ 1000 사이의 value 값을 넣어서 확인 

## 기능 Test
  1. 카메라 poe 전원주기
  2. nvr이 있다면 모든카메라의 화면 확인
  3. txt파일에 연결하고자하는 모든 ip 작성
  4. pc에서 프로그램 실행 -> 연결했던 모든 카메라가 1시간에 한번씩  pan tilt 변경 0,0 -> 50,50 -> 100,80 -> 0,0

## LongRun Test
   - Video Streaming
   - PTZ  API Call <-> Onvif Server + Schedule program
   - Configration(Django) 
   - Object Detection
   
   - send log to influxDB cloud(bit / logstas / influxdb)

## 문제 해결
  - 영상이 안보이거나 NVR 카메라연결이 안될때
   ```
    docker restart edge
   ```
  - ```
    docker 명령어 재실행
    ```

## nvr 카메라 연결
   - https://docs.google.com/document/d/1VF08EdpTQruhooPVtSs50QzwxWs8y4TaYX3Cy-dVags/edit?tab=t.0
