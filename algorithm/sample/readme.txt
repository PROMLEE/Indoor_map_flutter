1. 업로드 받는 데이터 - sample_image.jpg
2. AI 가공 후 결과 - mask.png
3. mask_to_json.py 를 통해 데이터 수치화(테두리만 남김)
	추가적으로 건물 정보, 경도, 위도, 층 데이터 저장
	-> data.json
4. data.json 에서 각 객체에 id, caption 값 줄 수 있음
5. json_to_mask.py 를 통해 json 파일 다시 시각화 -> edge.png


백엔드에 저장해야 할 파일:
sample_image.jpg
mask.png
data.json *중요*
edge.png