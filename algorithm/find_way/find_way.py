import cv2
import numpy as np
import json
from queue import Queue

# JSON 파일 경로
json_file_path = "algorithm/find_way/data.json"

# JSON 파일에서 데이터 읽기
with open(json_file_path, "r") as file:
    data = json.load(file)

# 마스크 이미지의 크기 설정
startPoint = 1
endPoint = 10
INF = float('inf')
st_Averx, st_Avery = 0, 0
div =1
board = [[0] * 512 for _ in range(512)]
next = [[[0,0] for _ in range(512)] for _ in range(512)]

# JSON 파일의 데이터를 사용하여 각 픽셀 위치에 점 찍기

height, width = 512, 512  # 실제 이미지 크기에 맞게 조정해야 합니다.
mask = np.zeros((height, width), dtype=np.uint8)
for group in data["EdgeData"]:
    if group["id"] == startPoint:
        div = len(group["pixels"])
    for pixel in group["pixels"]:
        if group["id"] == startPoint:
            st_Averx += pixel["x"]
            st_Avery += pixel["y"]
        else:
            x, y = pixel["x"], pixel["y"]
            mask[y, x] = 255
            board[y][x] = group["id"]

st_Averx//=div
st_Avery//=div
dx = [1, 0, -1, 0]
dy = [0, 1, 0, -1]
dist = [[-1] * 512 for _ in range(512)]
Q = Queue()
Q.put((st_Averx, st_Avery))
dist[st_Averx][st_Avery]=1
endX, endY = 0, 0
escape=True

while escape:
    cur = Q.get()
    for dir in range(4):
        nx = cur[0] + dx[dir]
        ny = cur[1] + dy[dir]
        # print(nx, ny)
        if board[ny][nx]==endPoint:
            endX, endY = nx,ny
            escape=False
            next[ny][nx] = (cur[0], cur[1])
            break
        elif nx<0 or nx>=512 or ny<0 or ny>=512 or dist[ny][nx]==1 or board[ny][nx]: continue
        Q.put((nx, ny))
        dist[ny][nx]=1
        next[ny][nx] = (cur[0], cur[1])
path = []
st = (endX, endY)
print(next[endY][endX])
while st != (st_Averx, st_Avery):
    path.append(st)
    print(st)
    mask[st[1],st[0]] = 255
    st = next[st[1]][st[0]]
path.append(st)
mask[st[1],st[0]] = 255
print(path)
mask_file_path ="algorithm/find_way/way/way.png"
cv2.imwrite(mask_file_path, mask)