import cv2
import numpy as np
import json


def is_boundary_pixel(x, y, mask, height, width):
    if x == 0 or x == width - 1 or y == 0 or y == height - 1:
        return True

    neighbors = [
        mask[y - 1, x - 1],
        mask[y - 1, x],
        mask[y - 1, x + 1],
        mask[y, x - 1],
        mask[y, x + 1],
        mask[y + 1, x - 1],
        mask[y + 1, x],
        mask[y + 1, x + 1],
    ]

    return not all(val == 255 for val in neighbors)


def find_connected_components(mask):
    num_labels, labels = cv2.connectedComponents(mask)
    return num_labels, labels


# 마스크 이미지 파일 경로
mask_file_path = "mask_sample.png"

# 이미지 파일 불러오기 (흑백 모드로 불러옴)
mask = cv2.imread(mask_file_path, cv2.IMREAD_GRAYSCALE)
height, width = mask.shape

new_mask = np.zeros((height, width), dtype=np.uint8)
for y in range(height):
    for x in range(width):
        if mask[y, x] == 255 and is_boundary_pixel(x, y, mask, height, width):
            new_mask[y, x] = 255

# 연결된 구성 요소 찾기
num_labels, labels = find_connected_components(new_mask)

# 각 구성 요소의 픽셀 위치 저장
components = {}
for y in range(height):
    for x in range(width):
        label = labels[y, x]
        if label > 0:  # 0은 배경을 의미함
            # NumPy intc 타입을 Python 기본 int 타입으로 변환
            components.setdefault(int(label), []).append({"x": int(x), "y": int(y)})

# JSON 파일로 저장할 데이터 생성
edge_data = []
for id, pixels in components.items():
    edge_data.append({"id": id, "caption": f"Edge Group {id}", "pixels": pixels})

# JSON 파일로 저장
json_file_path = "grouped_mask_data.json"
with open(json_file_path, "w") as file:
    json.dump(edge_data, file, indent=4)

print(f"Grouped mask data with IDs and captions saved to {json_file_path}")
