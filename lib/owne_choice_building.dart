import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:navermaptest01/owner.dart';

class OwnerChoiceBuilding extends StatelessWidget {
  OwnerChoiceBuilding({Key? key}) : super(key: key);

  final Completer<NaverMapController> _mapControllerCompleter =
      Completer<NaverMapController>();
  late NaverMapController _controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(30),
                  child: const Text("건물을\n선택하세요.",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 49, 49, 49),
                      )),
                ),
              ],
            ),
            Expanded(
              child: NaverMap(
                options: const NaverMapViewOptions(
                  locationButtonEnable: true,
                ),
                onMapTapped: (NPoint point, NLatLng latLng) async {
                  log("${latLng.latitude}");
                  log("${latLng.longitude}");
                  final marker = NMarker(id: "test", position: latLng);
                  _controller.addOverlay(marker);
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String buildingName = '';
                        String floorNumber = "";
                        return AlertDialog(
                          title: const Text(
                            "건물 정보 입력",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 49, 49, 49),
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("위도 : ${latLng.latitude}"),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("경도 : ${latLng.longitude}"),
                                ],
                              ),
                              TextField(
                                onChanged: (value) {
                                  buildingName = value;
                                },
                                decoration: const InputDecoration(
                                    labelText: "건물명을 입력하세요"),
                                keyboardType: TextInputType.name,
                              ),
                              TextField(
                                onChanged: (value) {
                                  floorNumber = value;
                                },
                                decoration: const InputDecoration(
                                    labelText: "층수를 입력하세요"),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  //입력을 안했을때 처리
                                  if (floorNumber == "" && buildingName == "") {
                                    Fluttertoast.showToast(
                                      msg: "층수와 건물명을 입력해주세요.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                  } else if (floorNumber == "") {
                                    Fluttertoast.showToast(
                                      msg: "층수를 입력해주세요.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                  } else if (buildingName == "") {
                                    Fluttertoast.showToast(
                                      msg: "건물명을 입력해주세요.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Owner(
                                          buildingName: buildingName,
                                          floorNumber: int.parse(floorNumber),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('안내도 업로드\t',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 49, 49, 49))),
                                    Icon(Icons.upload_file_outlined,
                                        color: Color.fromARGB(255, 49, 49, 49),
                                        size: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                onMapReady: (controller) {
                  _mapControllerCompleter.complete(controller);
                  _controller = controller;
                  log("건물주 네이버맵 준비완료!", name: "onMapReady");
                },
              ),
            ),
            //여기에 위젯 추가
          ],
        ),
      ),
    );
  }
}
