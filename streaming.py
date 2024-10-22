import cv2
import datetime
import os

def gstreamer_pipeline(
    sensor_id=0,
    capture_width=1920,
    capture_height=1080,
    display_width=1920,
    display_height=1080,
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

def show_camera():
    host_ip = os.getenv("HOST_IP")
    recode_out = cv2.VideoWriter('appsrc ! videoconvert' + \
                            ' ! x264enc speed-preset=ultrafast bitrate=3500 key-int-max=' + str(10) + \
                            ' ! video/x-h264,profile=baseline' + \
                            f' ! rtspclientsink location=rtsp://{host_ip}:8554/mystream',
                            cv2.CAP_GSTREAMER, 0, 15, (1920,1080), True)
    video_capture = cv2.VideoCapture(gstreamer_pipeline(flip_method=0), cv2.CAP_GSTREAMER)
    if video_capture.isOpened():
        try:
            while True:
                ret_val, frame = video_capture.read()
                # frame = cv2.resize(frame,(960,540))
                recode_out.write(frame)
                keyCode = cv2.waitKey(10) & 0xFF
                # Stop the program on the ESC key or 'q'
                if keyCode == 27 or keyCode == ord('q'):
                    break
        finally:
            video_capture.release()
            recode_out.release()
    else:
        print("Error: Unable to open camera")

if __name__ == "__main__":
    show_camera()