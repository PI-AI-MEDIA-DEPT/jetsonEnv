#!/bin/bash

# Stop and remove existing container if it exists
docker rm -f edge 2>/dev/null || true

# Run the container with log size limit
docker run --restart always -it \
  --name edge \
  --runtime nvidia \
  --device /dev/video0 \
  -e INFLUX_TOKEN=$INFLUX_TOKEN \
  -e INFLUX_BUCKET=$INFLUX_BUCKET \
  -e INFLUX_ORG=$INFLUX_ORG \
  -e INFLUX_HOST=$INFLUX_HOST \
  --env HOST_IP=$(hostname -I | awk '{print $1}') \
  --network host \
  --volume /tmp/argus_socket:/tmp/argus_socket \
  -v /home/jetson/jetsonEnv:/loc \
  -w /loc \
  --privileged \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=5 \
  aimedia/jetson-gst-yolov8:0.5 \
  python3 streaming.py