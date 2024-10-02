import cv2
import datetime
from ultralytics import YOLO
import os
from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS
import datetime

"""
gstreamer_pipeline returns a GStreamer pipeline for capturing from the CSI camera
Flip the image by setting the flip_method (most common values: 0 and 2)
display_width and display_height determine the size of each camera pane in the window on the screen
Default 1920x1080 displayd in a 1/4 size window
"""

def gstreamer_pipeline(
    sensor_id=0,
    capture_width=960,
    capture_height=540,
    display_width=960,
    display_height=540,
    framerate=15,
    flip_method=0,
):
    return (
        "nvarguscamerasrc sensor-id=%d ! "
        "video/x-raw(memory:NVMM), width=(int)%d, height=(int)%d, framerate=(fraction)%d/1 ! "
        "nvvidconv flip-method=%d ! "
        "video/x-raw, width=(int)%d, height=(int)%d, format=(string)BGRx ! "
        "videoconvert ! "
        "video/x-raw, format=(string)BGR ! appsink"
        % (
            sensor_id,
            capture_width,
            capture_height,
            framerate,
            flip_method,
            display_width,
            display_height,
        )
    )

def get_bottom_center(xmin, ymin, xmax, ymax):
    x_center = (xmin + xmax) / 2
    y_bottom = ymax
    return x_center, y_bottom

def show_camera():
    host_ip = os.getenv("HOST_IP")
    INFLUX_TOKEN = os.getenv("INFLUX_TOKEN")
    INFLUX_BUCKET = os.getenv("INFLUX_BUCKET")
    INFLUX_HOST = os.getenv("INFLUX_HOST")
    INFLUX_ORG = os.getenv("INFLUX_ORG")

    # Initialize the InfluxDB client
    client = InfluxDBClient(
        url=INFLUX_HOST,
        token=INFLUX_TOKEN,
        org=INFLUX_ORG
    )

    write_api = client.write_api(write_options=SYNCHRONOUS)

    model = YOLO('./yolov8n.pt')
    CONFIDENCE_THRESHOLD = 0.5
    GREEN = (0, 255, 0)
    WHITE = (255, 255, 255)
    recode_out = cv2.VideoWriter('appsrc ! videoconvert' + \
                            ' ! x264enc speed-preset=ultrafast bitrate=1400 key-int-max=' + str(15) + \
                            ' ! video/x-h264,profile=baseline' + \
                            f' ! rtspclientsink location=rtsp://{host_ip}:8554/mystream',
                            cv2.CAP_GSTREAMER, 0, 15, (960,540), True)
    print(gstreamer_pipeline(flip_method=0))
    video_capture = cv2.VideoCapture(gstreamer_pipeline(flip_method=0), cv2.CAP_GSTREAMER)
    if video_capture.isOpened():
        try:
            while True:
                start = datetime.datetime.now()
                ret_val, frame = video_capture.read()
                detection = model(frame, verbose=False)[0]
                for data in detection.boxes.data.tolist(): # data : [xmin, ymin, xmax, ymax, confidence_score, class_id]
                    confidence = float(data[4])
                    if confidence < CONFIDENCE_THRESHOLD:
                        continue
                    label = int(data[5])
                    if label == 0:
                        xmin, ymin, xmax, ymax = int(data[0]), int(data[1]), int(data[2]), int(data[3])
                        

                        cv2.rectangle(frame, (xmin, ymin), (xmax, ymax), GREEN, 2)
                        x_center, y_bottom = get_bottom_center(xmin, ymin, xmax, ymax)
                        point = (
                            Point("person_location")                            # Measurement name
                            .tag("clientIP", str(host_ip) )                     # Tag for person ID
                            .field("cx", x_center)                             # Field for X coordinate
                            .field("cy", y_bottom)                             # Field for Y coordinate                        # Optional: Field for Z coordinate
                            .time( datetime.datetime.utcnow(), WritePrecision.NS) # Timestamp
                        )
                        try:
                            write_api.write(bucket=INFLUX_BUCKET, org=INFLUX_ORG, record=point)
                        except Exception as E:
                            print(E)
                    else :
                        pass

                # end = datetime.datetime.now()
                # total = (end - start).total_seconds()
                # print(f'Time to process 1 frame: {total * 1000:.0f} milliseconds')
                #fps = f'FPS: {1 / total:.2f}'
                #print("FPS: ",fps)
                frame = cv2.resize(frame,(960,540))
                recode_out.write(frame)
                keyCode = cv2.waitKey(10) & 0xFF

                # Stop the program on the ESC key or 'q'
                if keyCode == 27 or keyCode == ord('q'):
                    break
        finally:
            video_capture.release()
            recode_out.release()
            client.close()
            # cv2.destroyAllWindows()
    else:
        print("Error: Unable to open camera")

if __name__ == "__main__":
    show_camera()