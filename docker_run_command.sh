#!/bin/bash 
docker run --rm -it --name edge --runtime nvidia --device /dev/video0 --env HOST_IP=$(hostname -I | awk '{print $1}') --network mtx --volume /tmp/argus_socket:/tmp/argus_socket -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix --privileged aimedia/jetson-gst-yolov8:0.4 bash
