# MK3 Check List



#IP Setting

  - 고정 아이피 세팅
  - HDMI 연결후에 하는 법
  - ``` Command line 으로 하는법 

  - 고정 아이피 변경
  - HDMI 연결후에 하는 법
  - Command line 으로 하는법

  - dhcp로 세팅
  - HDMI 연결후에 하는 법
  - Command line 으로 하는법

#Camera Check

  docker 실행시
  - mediamtx service check
  - camera fastapi service check
  - docker check
  - docker ps
  - http :8889 체크
  - nvr 체크
  - troubleshoting
  - docker restart
  - docker 명령어 재실행
  - systemctl restart service
    
  stream으로 실행시
  - docker rm -f 
  - mediamtx service stop
  - main.py 변경
  - camera fastapi service check
  - vlc 체크
  - nvr 체크

#LongRun Test

   - DHCP 경우
   - 고정 아이피인 경우

longrun test 
1. 카메라 poe 전원주기
2. nvr이 있다면 모든카메라의 화면 확인
3. txt파일에 연결하고자하는 모든 ip 작성
4. pc에서 프로그램 실행 -> 연결했던 모든 카메라가 1시간에 한번씩  pan tilt 변경 0,0 -> 50,50 -> 100,80 -> 0,0
   
