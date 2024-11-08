git hib
docker run --restart always -it --name edge --runtime nvidia --device /dev/video0 -e INFLUX_TOKEN=$INFLUX_TOKEN -e INFLUX_BUCKET=$INFLUX_BUCKET -e INFLUX_ORG=$INFLUX_ORG -e INFLUX_HOST=$INFLUX_HOST --env HOST_IP=$(hostname -I | awk '{print $1}') --network host --volume /tmp/argus_socket:/tmp/argus_socket -v /home/jetson/jetsonEnv:/loc -w /loc --privileged aimedia/jetson-gst-yolov8:0.5 python3 test.py

#onfail
docker run --restart on-failure:5 -it --name edge --runtime nvidia --device /dev/video0 -e INFLUX_TOKEN=$INFLUX_TOKEN -e INFLUX_BUCKET=$INFLUX_BUCKET -e INFLUX_ORG=$INFLUX_ORG -e INFLUX_HOST=$INFLUX_HOST --env HOST_IP=$(hostname -I | awk '{print $1}') --network host --volume /tmp/argus_socket:/tmp/argus_socket -v /home/jetson/jetsonEnv:/loc -w /loc --privileged aimedia/jetson-gst-yolov8:0.5 python3 test.py


#streaming
docker run --restart always -it --name edge --runtime nvidia --device /dev/video0 -e INFLUX_TOKEN=$INFLUX_TOKEN -e INFLUX_BUCKET=$INFLUX_BUCKET -e INFLUX_ORG=$INFLUX_ORG -e INFLUX_HOST=$INFLUX_HOST --env HOST_IP=$(hostname -I | awk '{print $1}') --network host --volume /tmp/argus_socket:/tmp/argus_socket -v /home/jetson/jetsonEnv:/loc -w /loc --privileged aimedia/jetson-gst-yolov8:0.5 python3 streaming.py
