import serial
import serial.tools.list_ports
import cv2
import numpy as np


def value_append(value_list, value):
    value_list.pop(0)
    value_list.append(value)
    return value_list


def value_plot(value_list):
    canvas = np.zeros((300, len(value_list) * 2, 3), dtype='uint8') + 255

    for i in range(len(value_list) - 1):
        if value_list[i] != None and value_list[i + 1] != None:
            left = (2 * i, 277 - value_list[i])  # 用 277 减数字是为了让数值越高位置越高，且画面居中
            right = (2 * (i + 1), 277 - value_list[i + 1])
            cv2.line(canvas, left, right, (0, 0, 0), 1)

    content = "Current Value = {}".format(value_list[-1])
    cv2.putText(canvas, content, (650, 35), cv2.FONT_ITALIC,
                fontScale=1, color=(129, 132, 0), thickness=2)

    return canvas


if __name__ == "__main__":
    port_list = list(serial.tools.list_ports.comports())
    print("\n检测到串口：")
    for i in range(0, len(port_list)):
        print("[ID:{}] {}".format(i, port_list[i]))

    inputerror = True  # 如果输入正确才会变为 False
    selected = input("\n请输入你想打开的串口在上述列表中的 ID:")
    if selected.isdigit():
        if int(selected) <= len(selected):
            selected_com = port_list[int(selected)]
            print("\n正在打开: {}".format(selected_com))
            print("在画面中按 'q' 键可以退出……")
            inputerror = False

    if inputerror:
        print("\n输入错误，只需输入上述列表中左侧列出的数字 ID 即可")
        exit(0)

    com = serial.Serial(selected_com[0], 115200, timeout=1)

    value_list = 500 * [None]

    while True:
        com.flushInput()
        value = com.read(1)
        if len(value) != 1:
            print("读取失败，请检查选择的串口是否正确")
            break

        value = int.from_bytes(value, byteorder='big', signed=False)
        value_list = value_append(value_list, value)
        canvas = value_plot(value_list)
        cv2.imshow("Press 'q' to exit.", canvas)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            cv2.destroyAllWindows()
            com.close()
            print("已正常退出。")
            break
