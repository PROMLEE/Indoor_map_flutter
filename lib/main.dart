import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:navermaptest01/Owner.dart';
import 'package:navermaptest01/visitor.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';


//TESTESTETETSTSETES

void main() async {
  await _initialize();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  runApp(MyApp());
}

Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    clientId: '29gnz8krk9',
    onAuthFailed: (e) => log("네이버맵 인증 오류 : $e", name: "Error")
  );
}

class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {

  FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(30),
                    child: const Text("실내\n길 찾기. \n\n당신의 목적은 ?",
                      style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 49, 49, 49),
                      )
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    width: 50,
                    height: 50
                  ),
                  OutlinedButton(onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) => const NaverMapApp(),
                        ),
                      );
                    }, child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text('방문객', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 49, 49, 49))),
                          Icon(Icons.people_alt_rounded, color: Color.fromARGB(255, 49, 49, 49), size: 150),
                        ],
                    ),
                  ),
                  const SizedBox(
                    width: 47.5,
                    height: 47.5
                  ),
                  const Divider(
                    thickness: 1, height: 1, color: Color.fromARGB(255, 170, 170, 170),
                  ),
                  const SizedBox(
                    width: 47.5,
                    height: 47.5
                  ),
                  OutlinedButton(onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) => const Owner(),
                        ),
                      );
                    }, child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text('건물주', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 49, 49, 49))),
                          Icon(Icons.business, color: Color.fromARGB(255, 49, 49, 49), size: 150),
                        ],
                    ),
                  ),
                ],
              )
            ]
          ),
      )
    );
  }
}