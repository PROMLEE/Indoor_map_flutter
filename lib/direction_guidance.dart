import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DirectionGuidance extends StatefulWidget {
  final String startFloor;
  final String startLocation;
  final String endFloor;
  final String endLocation;
  final String transportMethod;
  final dynamic data;

  const DirectionGuidance({
    required this.startFloor,
    required this.startLocation,
    required this.endFloor,
    required this.endLocation,
    required this.transportMethod,
    required this.data,
    Key? key,
  }) : super(key: key);
  @override
  State<DirectionGuidance> createState() => _DirectionGuidanceState();
}

class _DirectionGuidanceState extends State<DirectionGuidance> {
  String? _selectedFloor;
  String? _selectedLocation;
  bool _showLocationDropdown = false;

  //imageUrl을 초기값을 설정해줘야 예외 발생안됨 빈문자열 만듬
  String imageUrl = '';
  final storage = FirebaseStorage.instance;

  late String buildingName;

  @override
  void initState() {
    super.initState();
    //층, 출발지 선택을 할때마다 이미지를 가져오는 문제 찾음
    //문제라기보단 비효율적이니까
    //주소를 init할때 가져와서, 가져온 주소를 변수 상태로 저장
    //해서 해당 주소를 사용하면 될듯
    buildingName = widget.data['BuildingName'];
    _selectedFloor = widget.startFloor; // 초기 층을 출발 층으로 설정
    imageUrl = getImageurl();
    // getImageurl().then((url) {
    //   setState(() {
    //     imageUrl = url;
    //   });
    // });
  }

  String getImageurl() {
    return "http://54.180.106.175:5000/way/${buildingName}_${_selectedFloor!.padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    final startFloor = widget.startFloor; //출발 층
    final startLocation = widget.startLocation; //출발 장소
    final endFloor = widget.endFloor; //도착 층
    final endLocation = widget.endLocation; //도착 장소
    final transportMethod = widget.transportMethod;

    log(startFloor);
    log(startLocation);
    log(endFloor);
    log(endLocation);
    log(transportMethod);
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, top: 15),
                child: const Text(
                  "실내\n길 찾기.",
                  style: TextStyle(
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
              items: _getFloorList(), // 층 목록 설정
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
                _selectedFloor = value;
                _showLocationDropdown = true;
                imageUrl = getImageurl();
                setState(() {});
              },
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 170, 170, 170),
          ),
          //이미지 위젯
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
        ],
      ),
    );
  }

  List<String> _getFloorList() {
    int startFloor = 0;
    int endFloor = 0;
    bool isStartBasement = false;
    bool isEndBasement = false;

    if (widget.startFloor.startsWith('B')) {
      startFloor = int.tryParse(widget.startFloor.substring(1)) ?? 0;
      isStartBasement = true;
    } else {
      startFloor = int.tryParse(widget.startFloor) ?? 0;
    }

    if (widget.endFloor.startsWith('B')) {
      endFloor = int.tryParse(widget.endFloor.substring(1)) ?? 0;
      isEndBasement = true;
    } else {
      endFloor = int.tryParse(widget.endFloor) ?? 0;
    }

    final List<String> floorList = [];

    if (isStartBasement == isEndBasement) {
      if (startFloor <= endFloor) {
        for (int i = startFloor; i <= endFloor; i++) {
          floorList.add((isStartBasement ? 'B' : '') + i.toString());
        }
      } else {
        for (int i = startFloor; i >= endFloor; i--) {
          floorList.add((isStartBasement ? 'B' : '') + i.toString());
        }
      }
    } else {
      if (isStartBasement) {
        for (int i = startFloor; i >= 1; i--) {
          floorList.add('B$i');
        }
        for (int i = 1; i <= endFloor; i++) {
          floorList.add(i.toString());
        }
      } else {
        for (int i = startFloor; i >= 1; i--) {
          floorList.add(i.toString());
        }
        for (int i = 1; i <= endFloor; i++) {
          floorList.add('B$i');
        }
      }
    }

    return floorList;
  }
}
