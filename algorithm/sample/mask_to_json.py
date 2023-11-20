# import cv2
# import numpy as np
# import json


# def is_boundary_pixel(x, y, mask, height, width):
#     if x == 0 or x == width - 1 or y == 0 or y == height - 1:
#         return True

#     neighbors = [
#         mask[y - 1, x - 1],
#         mask[y - 1, x],
#         mask[y - 1, x + 1],
#         mask[y, x - 1],
#         mask[y, x + 1],
#         mask[y + 1, x - 1],
#         mask[y + 1, x],
#         mask[y + 1, x + 1],
#     ]

#     return not all(val == 255 for val in neighbors)

# def find_connected_components(mask):
#     num_labels, labels = cv2.connectedComponents(mask)
#     return num_labels, labels

# # 마스크 이미지 파일 경로
# mask_file_path = "mask.png"

# # 이미지 파일 불러오기 (흑백 모드로 불러옴)
# mask = cv2.imread(mask_file_path, cv2.IMREAD_GRAYSCALE)
# height, width = mask.shape

# new_mask = np.zeros((height, width), dtype=np.uint8)
# for y in range(height):
#     for x in range(width):
#         if mask[y, x] == 255:
#             new_mask[y, x] = 255

# # 연결된 구성 요소 찾기
# num_labels, labels = find_connected_components(new_mask)

# # 각 구성 요소의 픽셀 위치 저장
# components = {}
# for y in range(height):
#     for x in range(width):
#         label = labels[y, x]
#         if label > 0:  # 0은 배경을 의미함
#             # NumPy intc 타입을 Python 기본 int 타입으로 변환
#             components.setdefault(int(label), []).append({"x": int(x), "y": int(y)})

# # JSON 파일로 저장할 데이터 생성
# edge_data = []
# for id, pixels in components.items():
#     edge_data.append({"id": id, "caption": f"Edge Group {id}", "pixels": pixels})

# # JSON 파일로 저장
# json_file_path = "grouped_mask_data.json"
# with open(json_file_path, "w") as file:
#     json.dump(edge_data, file, indent=4)

# print(f"Grouped mask data with IDs and captions saved to {json_file_path}")
import cv2
import numpy as np
import math

def calculate_distance(x1, y1, x2, y2):
    return math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)

def is_within_distance(point1, point2, max_distance):
    return calculate_distance(point1[0], point1[1], point2[0], point2[1]) <= max_distance

def get_diagonal_neighbors(x, y, labels, current_label):
    neighbors = []
    for dx in [-1, 1]:
        for dy in [-1, 1]:
            nx, ny = x + dx, y + dy
            if 0 <= nx < width and 0 <= ny < height and labels[ny, nx] != current_label:
                neighbors.append((nx, ny))
    return neighbors

# 이미지 불러오기
mask_file_path = "mask.png"
mask = cv2.imread(mask_file_path, cv2.IMREAD_GRAYSCALE)
height, width = mask.shape

# 연결된 구성 요소 찾기
num_labels, labels = cv2.connectedComponents(mask)

# 새로운 마스크 준비
new_mask = np.zeros((height, width, 3), dtype=np.uint8)

# 각 구성 요소의 외곽선 찾기
contours = {}
for label in range(1, num_labels):
    component_mask = np.uint8(labels == label)
    contour, _ = cv2.findContours(component_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    contours[label] = contour[0]

# 외곽선 픽셀 간 거리 계산 및 채색
max_distance = 10
for label1 in contours:
    for label2 in contours:
        if label1 != label2:
            for point1 in contours[label1]:
                for point2 in contours[label2]:
                    if is_within_distance(point1[0], point2[0], max_distance):
                        cv2.line(new_mask, tuple(point1[0]), tuple(point2[0]), (0, 255, 0), 1)

# 대각선 이웃 사이의 픽셀 칠하기
for y in range(height):
    for x in range(width):
        current_label = labels[y, x]
        if current_label > 0:  # 배경은 무시
            diagonal_neighbors = get_diagonal_neighbors(x, y, labels, current_label)
            for nx, ny in diagonal_neighbors:
                mid_x, mid_y = (x + nx) // 2, (y + ny) // 2
                new_mask[mid_y, mid_x] = [0, 0, 255]  # 파란색으로 칠하기

# 원래 구성 요소 색상 적용
for y in range(height):
    for x in range(width):
        label = labels[y, x]
        if label > 0:
            new_mask[y, x] = [255, 255, 255]  # 흰색으로 적용

# 이미지 저장
cv2.imwrite("updated_mask.png", new_mask)
