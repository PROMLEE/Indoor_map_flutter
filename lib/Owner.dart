import 'dart:developer';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class Owner extends StatefulWidget {
  const Owner({Key? key}) : super(key: key);

  @override
  _OwnerState createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  int selectedFloor = 0; // 선택된 층을 저장하는 변수
  File? _image; // 선택된 이미지를 저장하는 변수

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Column(children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(30),
              child: const Text("건물\n안내도.",
                  style: TextStyle(
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
                          child: ListView(
                            children: <Widget>[
                              ListTile(
                                title: const Text("1층"),
                                onTap: () {
                                  setState(() {
                                    selectedFloor = 1;
                                  });
                                  log("1", name: "check");
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("2층"),
                                onTap: () {
                                  setState(() {
                                    selectedFloor = 2;
                                  });
                                  log("2", name: "check");
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("3층"),
                                onTap: () {
                                  setState(() {
                                    selectedFloor = 3;
                                  });
                                  log("3", name: "check");
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("4층"),
                                onTap: () {
                                  setState(() {
                                    selectedFloor = 4;
                                  });
                                  log("4", name: "check");
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("5층"),
                                onTap: () {
                                  setState(() {
                                    selectedFloor = 5;
                                  });
                                  log("5", name: "check");
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("6층"),
                                onTap: () {
                                  setState(() {
                                    selectedFloor = 6;
                                  });
                                  log("6", name: "check");
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("7층"),
                                onTap: () {
                                  setState(() {
                                    selectedFloor = 7;
                                  });
                                  log("7", name: "check");
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("8층"),
                                onTap: () {
                                  setState(() {
                                    selectedFloor = 8;
                                  });
                                  log("8", name: "check");
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("9층"),
                                onTap: () {
                                  setState(() {
                                    selectedFloor = 9;
                                  });
                                  log("9", name: "check");
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("10층"),
                                onTap: () {
                                  setState(() {
                                    selectedFloor = 10;
                                  });
                                  log("10", name: "check");
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("11층"),
                                onTap: () {
                                  setState(() {
                                    selectedFloor = 11;
                                  });
                                  log("11", name: "check");
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("12층"),
                                onTap: () {
                                  setState(() {
                                    selectedFloor = 12;
                                  });
                                  log("12", name: "check");
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("13층"),
                                onTap: () {
                                  setState(() {
                                    selectedFloor = 13;
                                  });
                                  log("13", name: "check");
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ));
                      });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    foregroundColor: const Color.fromARGB(255, 49, 49, 49)),
                child: Text("$selectedFloor층",
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
                  if (pickedFile != null) {
                    _image = File(pickedFile.path); //선택된 이미지 파일을 _image 변수에 저장
                  } else {
                    log("이미지가 선택되지 않았습니다 ㅋㅋ");
                  }
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
            log("이미지와 층을 선택해주세요");
            //안드로이드 스튜디오 처럼 플러터가 ToastMessage가 있는지 모르겠음 있으면 토스트메시지로 보내주면될듯
          } else if (_image == null) {
            log("이미지를 선택해주세요");
            //안드로이드 스튜디오 처럼 플러터가 ToastMessage가 있는지 모르겠음 있으면 토스트메시지로 보내주면될듯
          } else if (selectedFloor == 0) {
            log("층을 선택해주세요");
            //안드로이드 스튜디오 처럼 플러터가 ToastMessage가 있는지 모르겠음 있으면 토스트메시지로 보내주면될듯
          } else {
            //파이어베이스 연결필요
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
}
