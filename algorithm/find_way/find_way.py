import cv2
import numpy as np
import json
import os
from queue import Queue

startPoint,startfloor = 1,1
endPoint,endfloor = 50,5
dx = [1, 0, -1, 0,1,1,-1,-1]
dy = [0, 1, 0, -1,1,-1,1,-1]
# JSON 파일들의 기본 경로
base_path = "algorithm/result/"
# 파일명들을 나타내는 리스트
file_names = [("data01.json","way01.png"), ("data02.json","way02.png"), ("data03.json","way03.png"), ("data04.json","way04.png"), ("data05.json","way05.png")]

# 파일 경로 생성 및 처리를 위한 for문
for file_name in file_names:
    file_path = os.path.join(base_path, file_name[0])
    mask_path = os.path.join(base_path, file_name[1])
    # JSON 파일에서 데이터 읽기
    with open(file_path, "r") as file:
        data = json.load(file)

    # JSON 파일에서 데이터 읽기
    with open(json_file_path, "r") as file:
        data = json.load(file)

    # 마스크 이미지의 크기 설정
    startPoint = 1
    endPoint = 50
    board = [[0] * 513 for _ in range(513)]
    next = [[[0,0] for _ in range(513)] for _ in range(513)]
    len = len(data)
    # JSON 파일의 데이터를 사용하여 각 픽셀 위치에 점 찍기

    height, width = 512, 512  # 실제 이미지 크기에 맞게 조정해야 합니다.
    mask = np.zeros((height, width,3), dtype=np.uint8)
    for group in data:
        sum_x, sum_y = 0, 0
        div = 0
        id = group["id"]
        for pixel in group["pixels"]:
            x, y = pixel["x"], pixel["y"]
            if id != startPoint:
                board[y][x] = id
            sum_x += x
            sum_y += y
            div+=1
            mask[y, x] = 255
        mask = cv2.putText(mask, "caption", (sum_x//div, sum_y//div), cv2.ACCESS_READ, 0.3, (0,255,0), 1, cv2.LINE_AA)
        if id == startPoint:
            st_Averx, st_Avery = sum_x//div, sum_y//div

print(st_Averx, st_Avery)
dx = (1, 0, -1, 0,1,1,-1,-1)
dy = (0, 1, 0, -1,1,-1,1,-1)

Q = Queue()
Q.put((st_Averx, st_Avery))
board[st_Averx][st_Avery]=-1
escape=True

while escape:
    cur = Q.get()
    for dir in range(8):
        nx = cur[0] + dx[dir]
        ny = cur[1] + dy[dir]
        if board[ny][nx]==endPoint:
            endX, endY = nx,ny
            escape=False
            next[ny][nx] = (cur[0], cur[1])
            break
        elif 0<=nx<=512 and 0<=ny<=512 and board[ny][nx] == 0:
            # print(nx, ny, board[ny][nx])
            Q.put((nx, ny))
            next[ny][nx] = (cur[0], cur[1])
            board[ny][nx]=-1


path = []
st = (endX, endY)
# print(next[endY][endX])
while st != (st_Averx, st_Avery):
    path.append(st)
    # print(st)
    mask[st[1],st[0]] = [0, 0, 255]
    st = next[st[1]][st[0]]
path.append(st)
mask[st[1],st[0]] = [0, 0, 255]
# print(path)
mask_file_path ="algorithm/result/way.png"
cv2.imwrite(mask_file_path, mask)
