import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "api_key.dart";

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
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
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
  sendBuildingInfo(data) async {
    final firestore = FirebaseFirestore.instance;
    String documentId = data["Latitude"].toString().substring(5, 9) +
        data["Longitude"].toString().substring(5, 9);

    DocumentReference documentReference = firestore
        .collection('buildings') // 'buildings'는 컬렉션 이름
        .doc(documentId); // documentId는 문서 ID

    await documentReference.set(data);

    log("생성된 문서 ID: $documentId");
    log("됐쓰!!");
  }

  Future uploadFile(floor) async {
    if (_image == null) return;

    final uri = Uri.parse(
        'https://$apiUrl/upload/${buildingName}_${floor.padLeft(2, '0')}');
    // 'http://127.0.0.1:5000/upload/${buildingName}_${floor.padLeft(2, '0')}');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path));

    await request.send();
    log('파일 업로드 성공  ${buildingName}_${floor.padLeft(2, '0')}.png');
  }

  sendImg(img, floor) async {
    final storageRef = FirebaseStorage.instance.ref(buildingName);
    final testRef = storageRef.child("$buildingName$floor.png");
    await testRef.putFile(img);
    log("yayayayayayaayayay");
    Fluttertoast.showToast(
      msg: "안내도 업로드 완료",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  void initState() {
    sendBuildingInfo({
      "BuildingName": buildingName,
      "Latitude": nMarkerPosition.latitude,
      "Longitude": nMarkerPosition.longitude,
      "Floors": floorNumber,
      "Basement": basementNumber
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 15),
                  child: Text(
                    "$buildingName\n건물\n안내도.",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 49, 49, 49),
                    ),
                  ),
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
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        foregroundColor: const Color.fromARGB(255, 49, 49, 49)),
                    child: Text(
                      "${selectedFloor.toString().replaceAll('-', 'B')}층",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 49, 49, 49),
                      ),
                    ),
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
                    setState(
                      () {
                        _image = File(pickedFile!.path);
                        //선택된 이미지 파일을 _image 변수에 저장
                      },
                    );
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
                ),
              ],
            ),
            const Divider(thickness: 1, color: Colors.grey),
            _image == null
                ? const Text(
                    "이미지가 선택되지 않았습니다.",
                  )
                : Expanded(
                    child: Image.file(
                      _image!,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
          ],
        ),
        bottomNavigationBar: OutlinedButton(
          onPressed: () async {
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
              //_image는 Storage에 저장
              String floor = selectedFloor.toString().replaceAll("-", "B");
              log("업로드 하기 버튼 클릭");
              await uploadFile(floor);
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
      ),
    );
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
        floorList.add(
          ListTile(
            title: Text("B$i층"),
            onTap: () {
              setState(
                () {
                  selectedFloor = -i;
                },
              );
              log("-$i", name: "check");
              Navigator.pop(context);
            },
          ),
        );
      }
      for (int i = 1; i <= floorNumber; i++) {
        floorList.add(
          ListTile(
            title: Text("$i층"),
            onTap: () {
              setState(
                () {
                  selectedFloor = i;
                },
              );
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
