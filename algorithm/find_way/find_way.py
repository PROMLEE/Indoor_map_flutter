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
        
    st_Averx, st_Avery = 0, 0
    div =1
    board = [[0] * 513 for _ in range(513)]
    next = [[[0,0] for _ in range(513)] for _ in range(513)]

    # JSON 파일의 데이터를 사용하여 각 픽셀 위치에 점 찍기

    height, width = 512, 512  # 실제 이미지 크기에 맞게 조정해야 합니다.
    mask = np.zeros((height, width,3), dtype=np.uint8)
    for group in data:
        if group["id"] == startPoint:
            div = len(group["pixels"])
        for pixel in group["pixels"]:
            x, y = pixel["x"], pixel["y"]
            if group["id"] == -2:
                board[y][x] = -2
            elif group["caption"]=="elevator": board[y][x]=1000
            elif group["id"] == startPoint & startfloor==file_path[4:6] :
                st_Averx += x
                st_Avery += y
            else:
                board[y][x] = group["id"]
            mask[y, x] = 255

    st_Averx//=div
    st_Avery//=div
    Q = Queue()
    Q.put((st_Averx, st_Avery))
    board[st_Averx][st_Avery]=-1
    endX, endY = 0, 0
    escape=True
    cycle=False

    while escape:
        cur = Q.get()
        for dir in range(8):
            nx = cur[0] + dx[dir]
            ny = cur[1] + dy[dir]
            # print(nx, ny)
            if board[ny][nx]==endPoint & endfloor==file_path[4:6]:
                endX, endY = nx,ny
                escape=False
                next[ny][nx] = (cur[0], cur[1])
                cycle=True
                break
            elif board[ny][nx]==1000:
                endX, endY = nx,ny
                escape=False
                next[ny][nx] = (cur[0], cur[1])
                break
            elif nx<0 or nx>=512 or ny<0 or ny>=512 or board[ny][nx]==-1 or board[ny][nx] or board[ny][nx]==-2: continue
            Q.put((nx, ny))
            board[ny][nx]=-1
            next[ny][nx] = (cur[0], cur[1])
    path = []
    st = (endX, endY)
    print(next[endY][endX])
    while st != (st_Averx, st_Avery):
        path.append(st)
        print(st)
        mask[st[1],st[0]] = [0, 0, 255]
        st = next[st[1]][st[0]]
    path.append(st)
    mask[st[1],st[0]] = [0, 0, 255]
    print(path)
    cv2.imwrite(mask_path, mask)
    if(cycle): break



