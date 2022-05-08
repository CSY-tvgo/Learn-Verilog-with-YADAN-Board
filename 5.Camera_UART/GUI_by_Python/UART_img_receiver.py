#
# Author: Karbon
# GitHub: https://github.com/csy-tvgo
# Date:   2022-May-9
# Doc:    https://verimake.com/d/189
#

import serial
import serial.tools.list_ports
import cv2
import numpy as np
import time
import math
from datetime import datetime


def bytes_extract(raw_bytes, left, right):
    # extract the bit(s) of bytes
    a = int.from_bytes(raw_bytes, byteorder='big', signed=False)
    value = (((1 << (left + 1)) - 1) & a) >> right
    return int(value)


def depack(data):
    # depack the data of one pixel
    begin_frame = bytes_extract(data, 14, 14)
    begin_line = bytes_extract(data, 13, 13)
    pixel_R = bytes_extract(data, 12, 9)
    pixel_G = (bytes_extract(data, 8, 8) << 3) | bytes_extract(data, 6, 4)
    pixel_B = bytes_extract(data, 3, 0)
    pixel_R = pixel_R * (255 / 15)
    pixel_G = pixel_G * (255 / 15)
    pixel_B = pixel_B * (255 / 15)
    return begin_frame, begin_line, pixel_R, pixel_G, pixel_B


def com_read_pixel(com):
    # read the data of one pixel
    try:
        recvd = com.read(1)
        while bytes_extract(recvd, 7, 7) != 1:
            recvd = com.read(1)
        recvd += com.read(1)
        return recvd
    except:
        cv2.destroyAllWindows()
        com.close()
        print("[{}] Read COM port error! Please check the port selected.".format(
            datetime.now()))
        exit(0)


def detect_img_size(com):
    com.flushInput()
    while True:  # wait for the begin of a frame
        recvd = com_read_pixel(com)
        begin_frame, begin_line, _, _, _ = depack(recvd)
        if begin_frame == True:
            break
    pixel_count = 1
    line_count = 1
    while True:  # detect the height and width of a frame
        recvd = com_read_pixel(com)
        begin_frame, begin_line, _, _, _ = depack(recvd)
        if begin_frame == True:
            break
        pixel_count += 1
        if begin_line == True:
            line_count += 1

    height = line_count
    width = pixel_count // height
    print("[{}] Detected the size of a frame: height={}, width={}. Start to receiving...".format(
        datetime.now(), height, width))
    return height, width


if __name__ == "__main__":
    port_list = list(serial.tools.list_ports.comports())
    print("\nDetected COM ports:")
    for i in range(0, len(port_list)):
        print("    [ID:{}] {}".format(i, port_list[i]))

    inputerror = True  # will be turned to False when the input is correct
    selected = input("Please select the port which you want to open, ID:")
    if selected.isdigit():
        if int(selected) <= len(selected):
            selected_com = port_list[int(selected)]
            print("\n[{}] Opening: {}\n".format(datetime.now(), selected_com))
            inputerror = False

    if inputerror:
        print("\nYour input is error! Please only input the ID number in the list above.")
        exit(0)

    com = serial.Serial(selected_com[0], 240000, timeout=1)

    #
    # detect the height and the width of a frame
    #
    height, width = detect_img_size(com)

    #
    # start receiving and previewing
    #
    com.flushInput()

    canvas = np.zeros((height, width * 2, 3), dtype='uint8')

    line_buffer = []
    line_count = 0

    t0 = time.time()

    print("(Press 'q' in the preview window to exit, and 's' to snapshot)\n")
    while True:
        try:
            recvd = com_read_pixel(com)
            begin_frame, begin_line, pixel_R, pixel_G, pixel_B = depack(recvd)

            if begin_frame == True:   # copy the last received full frame to the right part of the window
                canvas[line_count, 0: len(line_buffer), :] = line_buffer
                canvas[:, width:] = canvas[:, 0: width].copy()
                line_count = -1

            if begin_line == True:   # draw the last received line in the left part of the window
                if line_count != -1:
                    canvas[line_count, 0: len(line_buffer), :] = line_buffer
                line_buffer = []
                line_count += 1

                if line_count % 4 == 0 or line_count == height:  # display the preview
                    preview_0 = canvas.copy()
                    preview_0[line_count: line_count + 1, 0: width, :] = 255 - \
                        preview_0[line_count: line_count + 1, 0: width, :]
                    preview_0 = cv2.resize(
                        preview_0, (width * 8, height * 4), interpolation=cv2.INTER_NEAREST)

                    preview_1 = np.zeros(
                        (height * 4 + 150, width * 8 + 150, 3), dtype='uint8') + 255
                    preview_1[60: 60 + height * 4, 50: 50 +
                              width * 4, :] = preview_0[:, : width * 4, :]
                    preview_1[60: 60 + height * 4, 100 + width *
                              4: 100 + width * 8, :] = preview_0[:, width * 4:, :]

                    text = "(auto detected) width=={}px, height=={}px, com.in_waiting=={}, line_count=={}".format(
                        width, height, com.in_waiting, line_count)
                    preview_1 = cv2.putText(
                        preview_1, text, (50, 40), cv2.FONT_HERSHEY_COMPLEX, 0.5, (0, 0, 0), 1)
                    text = "Receiving..."
                    preview_1 = cv2.putText(preview_1, text, (int(
                        50 + width * 1.25), height * 4 + 110), cv2.FONT_ITALIC, 1, (0, 0, 0), 2)
                    text = "Last Received Frame"
                    preview_1 = cv2.putText(preview_1, text, (int(
                        100 + width * 4.5), height * 4 + 110), cv2.FONT_ITALIC, 1, (0, 0, 0), 2)

                    theta = 2 * math.pi * line_count / height
                    x0, y0 = 50 + width * 1.05, height * 4 + 98
                    preview_1 = cv2.line(preview_1,
                                         (int(x0), int(y0)),
                                         (int(x0 + 15 * math.cos(theta)),
                                             int(y0 + 15 * math.sin(theta))),
                                         (0, 0, 0), 2)

                    cv2.imshow(
                        "Preview (press 'q' to exit, 's' to snapshot)\n", preview_1)
                    # cv2.imshow("raw test", canvas)
                    # print("{}:UART接收缓存长度：{}, len(buffer)={}".format(time.time() - t0, com.in_waiting, len(line_buffer)))
                    pressedKey = cv2.waitKey(1)
                    if pressedKey & 0xFF == ord('q'):
                        cv2.destroyAllWindows()
                        com.close()
                        print("[{}] Exit successfully.".format(datetime.now()))
                        break
                    elif pressedKey & 0xFF == ord('s'):
                        snapshotname = datetime.now().strftime("./snapshot_%Y%m%d_%H%M%S.jpg")
                        cv2.imwrite(snapshotname, preview_1)
                        print("[{}] Saved snapshot as {}".format(
                            datetime.now(), snapshotname))

            # append the pixel
            line_buffer.append([pixel_B, pixel_G, pixel_R])

        except Exception as e:
            print("[{}] Met an error: {}".format(datetime.now(), str(e)))
            print("[{}] Retrying...\n".format(datetime.now()))
            time.sleep(1)
            com.flushInput()
            height, width = detect_img_size(com)
            canvas = np.zeros((height, width * 2, 3), dtype='uint8')
            line_buffer = []
            line_count = 0
