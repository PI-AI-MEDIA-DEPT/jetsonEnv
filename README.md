# MK3 Check List



## IP Setting

  ### 고정 아이피 세팅
   Command line 으로 하는법
  - ```
    nmcli connection show
    nmcli device status

    create network profile 
    static-ip
    sudo nmcli connection add type ethernet ifname eth0 con-name static-ip autoconnect no ip4 192.168.x.x/24

    dhcp
    sudo nmcli connection add type ethernet ifname eth0 con-name dhcp-ip ipv4.method auto

    swithch network profile DHCP -> STATIC

    sudo nmcli connection modify dhcp-ip connection.autoconnect no
    sudo nmcli connection modify static-ip connection.autoconnect yes

    sudo reboot
    
    ```
  
  ### 고정 아이피 변경
  Command line 으로 하는법
  - ```
    modify static ip address
    sudo nmcli connection modify static-ip ipv4.addresses 192.168.1.102/24
    sudo reboot
    
    opt1. sudo nmcli connection modify static-ip ipv4.gateway 192.168.1.1
    opt2. sudo nmcli connection modify static-ip ipv4.dns "8.8.8.8 1.1.1.1"

    ip addr show eth0
    ```

  ### DHCP 세팅
  Command line 으로 하는법
  - ```
    swithch network profile DHCP -> STATIC

    sudo nmcli connection modify static-ip connection.autoconnect no
    sudo nmcli connection modify dhcp-ip connection.autoconnect yes

    sudo reboot
    ```


  ### sunba camera ip setting
  - vms 통해서 변경

## Camera Check

  ### docker 실행시
  - mediamtx service check
  - camera fastapi service check
  - docker check
  - docker ps
  - http :8889 체크
  - nvr 체크
  - troubleshoting
  - docker restart
  - ```
    docker 명령어 재실행
    ```
  - systemctl restart service
    
  ### stream으로 실행시
  - docker rm -f 
  - mediamtx service stop
  - main.py 변경
  - camera fastapi service check
  - vlc 체크
  - nvr 체크

## Focus 체크


## LongRun Test

   - DHCP 경우
   - 고정 아이피인 경우

   - Video Streaming
   - PTZ  API Call <-> Onvif Server + Schedule program
   - Configration(Django) 
   - Object Detection
   
   
   - send log to influxDB cloud(bit / logstas / influxdb)


longrun test 
1. 카메라 poe 전원주기
2. nvr이 있다면 모든카메라의 화면 확인
3. txt파일에 연결하고자하는 모든 ip 작성
4. pc에서 프로그램 실행 -> 연결했던 모든 카메라가 1시간에 한번씩  pan tilt 변경 0,0 -> 50,50 -> 100,80 -> 0,0
   
