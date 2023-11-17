import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({required this.marker, Key? key}) : super(key: key);
  final NMarker marker;

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30, top: 30),
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
          Expanded(
            flex: 0,
            child: Padding(
                padding: const EdgeInsets.only(left: 35),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      items: const ["1", "2", "3", "4"],
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            labelText: "층",
                            hintText: "층 선택",
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            hintStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      onChanged: print,
                    ),
                    DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      items: const ["A", "B", "C", "D"],
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            labelText: "매장명",
                            hintText: "매장 선택",
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            hintStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      onChanged: print,
                    ),
                  ],
                ))),
          ),
          const Divider(
            color: Color.fromARGB(255, 170, 170, 170),
          ),
          //이미지 위젯
          Expanded(
              child: InteractiveViewer(
            scaleEnabled: false,
            constrained: false,
            child: Image.network(
              'https://www.kindacode.com/wp-content/uploads/2020/12/the-cat.jpg',
            ),
          ))
        ],
      ),
    );
  }
}
