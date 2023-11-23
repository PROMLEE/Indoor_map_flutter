import cv2
image = cv2.imread('algorithm\sources\mask.png')
image = cv2.resize(image, (1024, 1024))

cv2.imwrite('algorithm\sources/sss.png', image)
# image.open('algorithm\sources/sss.png')