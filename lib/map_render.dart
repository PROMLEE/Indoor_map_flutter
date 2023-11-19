import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({required this.marker, Key? key}) : super(key: key);
  final NMarker marker;

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  //imageUrl을 초기값을 설정해줘야 예외 발생안됨 빈문자열 만듬
  String imageUrl = '';
  final storage = FirebaseStorage.instance;

  String? _selectedFloor;
  String? _selectedLocation;
  bool _showLocationDropdown = false;

  @override
  void initState() {
    super.initState();
    //층, 출발지 선택을 할때마다 이미지를 가져오는 문제 찾음
    //문제라기보단 비효율적이니까
    //주소를 init할때 가져와서, 가져온 주소를 변수 상태로 저장
    //해서 해당 주소를 사용하면 될듯
    getImageurl().then((url) {
      setState(() {
        imageUrl = url;
      });
    });
  }

  Future<String> getImageurl() async {
    final ref = storage.ref().child('CAU_310/CAU_310_6.png');
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    log(imageUrl);
    return Scaffold(
      body: Column(
        children: <Widget>[
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
              items: const ["1", "2", "3", "4"],
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    labelText: "층",
                    hintText: "층 선택",
                    labelStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    hintStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedFloor = value;
                  _showLocationDropdown = true;
                });
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
                items: const ["A", "B", "C", "D"],
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      labelText: "출발지 선택",
                      hintText: "가장 가까운 매장 선택",
                      labelStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      hintStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                },
              ),
            ),
          if (_selectedLocation != null)
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
                  onPressed: () {},
                  child: const Text("출발지 선택 완료")),
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
}
