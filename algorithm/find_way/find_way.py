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
st_Aver1, st_Aver2 = 0, 0
div =1
board = [[0] * 512 for _ in range(512)]
next = [[(-1, -1) for _ in range(512)] for _ in range(512)]

# JSON 파일의 데이터를 사용하여 각 픽셀 위치에 점 찍기
for i in range(1, len(data["EdgeData"])):
    height, width = 512, 512  # 실제 이미지 크기에 맞게 조정해야 합니다.
    mask = np.zeros((height, width), dtype=np.uint8)
    for group in data["EdgeData"]:
        if group["id"] == i:
            for pixel in group["pixels"]:
                x, y = pixel["x"], pixel["y"]
                mask[y, x] = 255
                board[y][x] = i
                if group["id"] == startPoint:
                    st_Aver1 += y
                    st_Aver2 += x
                    div = len(data["EdgeData"][0]["pixels"])
                if group["id"] == endPoint:
                    board[y][x] = "end"
    # 마스크 이미지 저장
    mask_file_path = "edge_id/edge_" + str(i) + ".png"
    cv2.imwrite(mask_file_path, mask)
st_Aver1//=div
st_Aver2//=div
dx = [1, 0, -1, 0,1,1,-1,-1]
dy = [0, 1, 0, -1,1,-1,1,-1]
dist = [[-1] * 512 for _ in range(512)]
Q = Queue()
Q.put((st_Aver1, st_Aver2))
dist[st_Aver1][st_Aver2]=1
endX, endY = 0, 0
while not Q.empty():
    cur = Q.get()
    if board[cur[0]][cur[1]] == "end":
        break
    for dir in range(8):
        nx = cur[0] + dx[dir]
        ny = cur[1] + dy[dir]
        if nx<0 or nx>=512 or ny<0 or ny>=512: continue
        if dist[nx][ny]==1: continue
        if board[nx][ny]=="end": 
            endX, endY = nx,ny
            break
        Q.put((nx, ny))
        dist[nx][ny]=1
        next[nx][ny] = (cur[0], cur[1])

path = []
st = (endX, endY)
while st != (st_Aver1, st_Aver2):
    path.append(st)
    mask[int(st[0]), int(st[1])] = 255
    print(st)
    st = next[int(st[0])][int(st[1])]
path.append(st)
mask[int(st[0]), int(st[1])] = 255
print(st)
mask_file_path = "edge_id/path_" + "22" + ".png"
cv2.imwrite(mask_file_path, mask)
