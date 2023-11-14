import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Owner extends StatefulWidget {
  final String buildingName;
  final int floorNumber;
  final NLatLng nMarkerPosition;
  final int? basementNumber;

  const Owner({
    Key? key,
    required this.buildingName,
    required this.floorNumber,
    required this.nMarkerPosition,
    this.basementNumber,
  }) : super(key: key);

  @override
  _OwnerState createState() => _OwnerState(
        buildingName: buildingName,
        floorNumber: floorNumber,
        nMarkerPosition: nMarkerPosition,
        basementNumber: basementNumber,
      );
}

class _OwnerState extends State<Owner> {
  int selectedFloor = 0; // 선택된 층을 저장하는 변수
  File? _image; // 선택된 이미지를 저장하는 변수

  final String buildingName;
  final int floorNumber;
  final NLatLng nMarkerPosition;
  final int? basementNumber;

  _OwnerState({
    required this.buildingName,
    required this.floorNumber,
    required this.nMarkerPosition,
    this.basementNumber,
  });
  sendData(file) async {
    final storageRef = FirebaseStorage.instance.ref();
    final testRef = storageRef.child("Test2.png");
    await testRef.putFile(file);
    log("yeayaeyaeya");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Column(children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(30),
              child: Text("$buildingName\n건물\n안내도.",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 49, 49, 49),
                  )),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SizedBox(
                            width: double.maxFinite,
                            child: createFloorList(),
                          ),
                        );
                      });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    foregroundColor: const Color.fromARGB(255, 49, 49, 49)),
                child: Text("${selectedFloor.toString().replaceAll('-', 'B')}층",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 49, 49, 49),
                    )),
              ),
            ),
            Container(
              width: 1,
              height: 30,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 12.5,
            ),
            TextButton(
              onPressed: () async {
                final picker = ImagePicker();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _image = File(pickedFile!.path); //선택된 이미지 파일을 _image 변수에 저장
                });
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "업로드할 안내도",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 49, 49, 49),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.image_search,
                    size: 22,
                    color: Color.fromARGB(255, 49, 49, 49),
                  ),
                ],
              ),
            )
          ],
        ),
        const Divider(thickness: 1, color: Colors.grey),
        _image == null
            ? const Text("이미지가 선택되지 않았습니다.")
            : Expanded(
                child: Image.file(_image!,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity),
              ),
      ]),
      bottomNavigationBar: OutlinedButton(
        onPressed: () {
          if (_image == null && selectedFloor == 0) {
            Fluttertoast.showToast(
              msg: "이미지와 층을 선택해주세요",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          } else if (_image == null) {
            Fluttertoast.showToast(
              msg: "이미지를 선택해주세요",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          } else if (selectedFloor == 0) {
            Fluttertoast.showToast(
              msg: "층을 선택해주세요",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          } else {
            //파이어베이스 연결필요
            //_image는 Storage에 저장
            //buildingName : String, floorNumber : Integer, basementNumber : Integer, nMarkerPosition.latitude : double, nMarkerPosition.longtitude : double,
            //  "BuildingInfo": {
            //   "BuildingName": "Building A",
            //   "Latitude": 37.7749,
            //   "Longitude": -122.4194,
            //   "Floors": 5,
            //   "Basement": 2
            // }
            sendData(_image);
            log("업로드 하기 버튼 클릭");
          }
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('업로드 하기\t',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 49, 49, 49))),
            Icon(Icons.upload_file_outlined,
                color: Color.fromARGB(255, 49, 49, 49), size: 20),
          ],
        ),
      ),
    ));
  }

  Widget createFloorList() {
    List<Widget> floorList = [];

    if (basementNumber == null) {
      //지하가 없는 건물
      for (int i = 1; i <= floorNumber; i++) {
        floorList.add(
          ListTile(
            title: Text("$i층"),
            onTap: () {
              setState(() {
                selectedFloor = i;
              });
              log("$i", name: "check");
              Navigator.pop(context);
            },
          ),
        );
      }
    } else if (basementNumber != null) {
      //null이 아니면 값이 전달받아진거니까 지하가 있는 건물
      for (int i = 1; i <= basementNumber!; i++) {
        floorList.add(ListTile(
          title: Text("B$i층"),
          onTap: () {
            setState(() {
              selectedFloor = -i;
            });
            log("-$i", name: "check");
            Navigator.pop(context);
          },
        ));
      }
      for (int i = 1; i <= floorNumber; i++) {
        floorList.add(
          ListTile(
            title: Text("$i층"),
            onTap: () {
              setState(() {
                selectedFloor = i;
              });
              log("$i", name: "check");
              Navigator.pop(context);
            },
          ),
        );
      }
    }
    return ListView(children: floorList);
  }
}
