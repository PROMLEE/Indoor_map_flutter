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

  bool isSwitched = false;

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
                  final onMarkerInfoWindow = NInfoWindow.onMarker(
                      id: marker.info.id, text: "해당 건물이 맞으시면\n 마커를 눌러주세요!");
                  _controller.addOverlay(marker);
                  marker.openInfoWindow(onMarkerInfoWindow);
                  marker.setOnTapListener((marker) {
                    log("${marker.position}");
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String buildingName = "";
                          String floorNumber = "";
                          String basementNumber = "";
                          NLatLng markerPosition = marker.position;
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: const Text(
                                "건물 정보 입력",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 49, 49, 49),
                                ),
                              ),
                              content: SingleChildScrollView(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("위도 : ${latLng.latitude}"),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("경도 : ${latLng.longitude}"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text("건물에 지하가 있나요?"),
                                      Switch(
                                        value: isSwitched,
                                        onChanged: (value) {
                                          setState(() {
                                            isSwitched = value;
                                          });
                                        },
                                        activeColor: Colors.green,
                                      )
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
                                  isSwitched
                                      ? TextField(
                                          onChanged: (value) {
                                            basementNumber = value;
                                          },
                                          decoration: const InputDecoration(
                                              labelText: "지하 층수를 입력하세요"),
                                          keyboardType: TextInputType.number,
                                        )
                                      : Container(),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      //입력을 안했을때 처리
                                      if (isSwitched == false) {
                                        if (floorNumber == "" &&
                                            buildingName == "") {
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
                                                floorNumber:
                                                    int.parse(floorNumber),
                                                nMarkerPosition: markerPosition,
                                              ),
                                            ),
                                          );
                                        }
                                      } else if (isSwitched) {
                                        //true일때 따로 처리
                                        if (floorNumber == "" &&
                                            basementNumber == "" &&
                                            buildingName == "") {
                                          Fluttertoast.showToast(
                                            msg: "건물명, 층수, 지하층수를 입력하세요",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                        } else if (buildingName == "" &&
                                            floorNumber == "" &&
                                            basementNumber != "") {
                                          Fluttertoast.showToast(
                                            msg: "건물명, 층수를 입력하세요",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                        } else if (buildingName == "" &&
                                            basementNumber == "" &&
                                            floorNumber != "") {
                                          Fluttertoast.showToast(
                                            msg: "건물명, 지하층수를 입력하세요",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                        } else if (floorNumber == "" &&
                                            basementNumber == "" &&
                                            buildingName != "") {
                                          Fluttertoast.showToast(
                                            msg: "층수, 지하층수를 입력하세요",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                        } else if (buildingName == "") {
                                          Fluttertoast.showToast(
                                            msg: "건물명을 입력하세요",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                        } else if (floorNumber == "") {
                                          Fluttertoast.showToast(
                                            msg: "층수를 입력하세요",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                        } else if (basementNumber == "") {
                                          Fluttertoast.showToast(
                                            msg: "지하 층수를 입력하세요",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      Owner(
                                                          buildingName:
                                                              buildingName,
                                                          floorNumber:
                                                              int.parse(
                                                                  floorNumber),
                                                          nMarkerPosition:
                                                              markerPosition,
                                                          basementNumber: int.parse(
                                                              basementNumber))));
                                        }
                                      }
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "안내도 업로드\t",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 49, 49, 49),
                                          ),
                                        ),
                                        Icon(Icons.upload_file_outlined,
                                            color:
                                                Color.fromARGB(255, 49, 49, 49),
                                            size: 20)
                                      ],
                                    ),
                                  )
                                ],
                              )),
                            );
                          });
                        });
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
