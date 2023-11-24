import cv2
image = cv2.imread('algorithm\sources/full_mask.png')
image = cv2.resize(image, (1024, 1024), interpolation=cv2.INTER_AREA)

cv2.imwrite('algorithm\sources/maks_1024.png', image)
# image.open('algorithm\sources/sss.png')