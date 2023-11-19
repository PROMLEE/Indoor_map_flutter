import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DirectionGuidance extends StatefulWidget {
  final String startFloor;
  final String startLocation;
  final String endFloor;
  final String endLocation;
  final String imageUrl;

  const DirectionGuidance({
    required this.startFloor,
    required this.startLocation,
    required this.endFloor,
    required this.endLocation,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);
  @override
  State<DirectionGuidance> createState() => _DirectionGuidanceState();
}

class _DirectionGuidanceState extends State<DirectionGuidance> {
  String? _selectedFloor;
  String? _selectedLocation;
  bool _showLocationDropdown = false;

  @override
  Widget build(BuildContext context) {
    final startFloor = widget.startFloor; //출발 층
    final startLocation = widget.startLocation; //출발 장소
    final endFloor = widget.endFloor; //도착 층
    final endLocation = widget.endLocation; //도착 장소
    final imageUrl = widget.imageUrl;
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
              onChanged: (value) {
                setState(() {
                  // 선택된 층 처리
                  _selectedFloor = value;
                  _showLocationDropdown = true;
                });
              },
            ),
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
        ],
      ),
    );
  }

  List<String> _getFloorList() {
    final startFloor = int.tryParse(widget.startFloor) ?? 0;
    final endFloor = int.tryParse(widget.endFloor) ?? 0;
    final List<String> floorList = [];

    if (startFloor <= endFloor) {
      for (int i = startFloor; i <= endFloor; i++) {
        floorList.add(i.toString());
      }
    } else {
      for (int i = startFloor; i >= endFloor; i--) {
        floorList.add(i.toString());
      }
    }

    floorList.sort(); // 리스트를 오름차순으로 정렬

    return floorList;
  }
}
