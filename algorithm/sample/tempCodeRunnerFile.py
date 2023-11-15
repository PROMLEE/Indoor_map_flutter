여 각 픽셀 위치에 점 찍기
# for group in data["EdgeData"]:
#     for pixel in group["pixels"]:
#         x, y = pixel["x"], pixel["y"]
#         mask[y, x] = 255

# # 마스크 이미지 저장
# mask_file_path = "edge.png"
# cv2.imwrite(mask_file_path, mask)