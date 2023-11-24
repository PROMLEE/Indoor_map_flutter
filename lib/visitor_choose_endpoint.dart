import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:navermaptest01/direction_guidance.dart';

class VisitorChooseEndPoint extends StatefulWidget {
  final String selectedFloor;
  final String selectedLocation;
  final dynamic data;
  final String documentId;

  const VisitorChooseEndPoint({
    required this.selectedFloor,
    required this.selectedLocation,
    required this.data,
    required this.documentId,
    Key? key,
  }) : super(key: key);

  @override
  State<VisitorChooseEndPoint> createState() => _VisitorChooseEndPointState();
}

class _VisitorChooseEndPointState extends State<VisitorChooseEndPoint> {
  List<String> _storeNames = []; // 매장명들을 저장할 List

  String imageUrl = '';
  final storage = FirebaseStorage.instance;

  String? _selectedFloorEndPoint;
  String? _selectedLocationEndPoint;
  bool _showLocationDropdown = false;

  late String buildingName;

  @override
  void initState() {
    super.initState();
    //층, 출발지 선택을 할때마다 이미지를 가져오는 문제 찾음
    //문제라기보단 비효율적이니까
    //주소를 init할때 가져와서, 가져온 주소를 변수 상태로 저장
    //해서 해당 주소를 사용하면 될듯
    buildingName = widget.data['BuildingName'];
    _selectedFloorEndPoint = widget.selectedFloor; // 초기 층을 출발 층으로 설정
    getImageurl().then((url) {
      setState(() {
        imageUrl = url;
      });
    });
  }

  Future<String> getImageurl() async {
    final ref = storage
        .ref()
        .child('$buildingName/${buildingName}_$_selectedFloorEndPoint.png');
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.data.toString());
    int? basementFloor = widget.data['Basement'];
    int floors = widget.data['Floors'];

    final selectedFloor = widget.selectedFloor;
    final selectedLocation = widget.selectedLocation;
    log(selectedLocation);
    //전달받은 출발한 층과 장소
    log(selectedFloor);
    return Scaffold(
      body: Column(children: <Widget>[
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, top: 15),
              child: Text(
                "$buildingName\n실내\n길 찾기.",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 49, 49, 49),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: DropdownSearch<String>(
            popupProps: PopupProps.menu(
              showSelectedItems: true,
              disabledItemFn: (String s) => s.startsWith('I'),
            ),
            items: createFloorList(basementFloor, floors),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                  labelText: "층",
                  hintText: "층 선택",
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  hintStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            onChanged: (value) async {
              _selectedFloorEndPoint = value;
              _showLocationDropdown = true;
              imageUrl = await getImageurl();
              DocumentSnapshot storeDocument = await FirebaseFirestore.instance
                  .collection('buildings')
                  .doc(widget.documentId)
                  .collection('stores')
                  .doc('${widget.documentId}_$_selectedFloorEndPoint')
                  .get();
              var tempData = storeDocument.data()
                  as Map<String, dynamic>; // 데이터를 Map 형태로 받음
              _storeNames = tempData.values
                  .toList()
                  .cast<String>(); // Map의 value들을 List로 변환
              setState(() {});
            },
          ),
        ),
        if (_showLocationDropdown)
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                disabledItemFn: (String s) => s.startsWith('I'),
              ),
              items: _storeNames,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    labelText: "도착지 선택",
                    hintText: "가고싶은 매장 선택",
                    labelStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    hintStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedLocationEndPoint = value;
                });
              },
            ),
          ),
        if (_selectedLocationEndPoint != null)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor:
                      const Color.fromARGB(255, 49, 49, 49), // 버튼의 텍스트 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 버튼의 모서리를 둥글게
                  ),
                ),
                onPressed: () {
                  if (_selectedFloorEndPoint != null &&
                      _selectedLocationEndPoint != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DirectionGuidance(
                          startFloor: selectedFloor,
                          startLocation: selectedLocation,
                          endFloor: _selectedFloorEndPoint!,
                          endLocation: _selectedLocationEndPoint!,
                          data: widget.data,
                        ),
                      ),
                    );
                  }
                },
                child: const Text("도착지 선택 완료")),
          ),
        const Divider(
          color: Color.fromARGB(255, 170, 170, 170),
        ),
        Expanded(
          child: imageUrl.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : InteractiveViewer(
                  maxScale: 5.0,
                  minScale: 0.01,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
        ),
      ]),
    );
  }

  List<String> createFloorList(int? basementFloor, int floors) {
    List<String> floorList = [];
    if (basementFloor != null) {
      for (int i = basementFloor; i >= 1; i--) {
        floorList.add("B$i");
      }
    }
    for (int i = 1; i <= floors; i++) {
      floorList.add("$i");
    }
    return floorList;
  }
}
