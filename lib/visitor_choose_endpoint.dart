import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:navermaptest01/direction_guidance.dart';

class VisitorChooseEndPoint extends StatefulWidget {
  final String selectedFloor;
  final String selectedLocation;
  final String imageUrl;

  const VisitorChooseEndPoint({
    required this.selectedFloor,
    required this.selectedLocation,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<VisitorChooseEndPoint> createState() => _VisitorChooseEndPointState();
}

class _VisitorChooseEndPointState extends State<VisitorChooseEndPoint> {
  String? _selectedFloorEndPoint;
  String? _selectedLocationEndPoint;
  bool _showLocationDropdown = false;

  @override
  Widget build(BuildContext context) {
    final selectedFloor = widget.selectedFloor;
    final selectedLocation = widget.selectedLocation;
    final imageUrl = widget.imageUrl;
    //전달받은 출발한 층과 장소
    log(imageUrl);
    return Scaffold(
      body: Column(children: <Widget>[
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
            items: const ["1", "2", "3", "4", "5"],
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
                _selectedFloorEndPoint = value;
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
              items: const ["A", "B", "C", "D", "E"],
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
}
