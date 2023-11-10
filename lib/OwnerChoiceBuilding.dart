import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:navermaptest01/Owner.dart';

class OwnerChoiceBuilding extends StatelessWidget {
  const OwnerChoiceBuilding({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final Completer<NaverMapController> mpaControllerCompleter = Completer();
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
                    )
                  ),
                ),
              ],
            ),
            Expanded(
              child: NaverMap(
                options: const NaverMapViewOptions(
                  // initialCameraPosition: NCameraPosition(
                  //   target: NLatLng(marker.position.latitude,marker.position.longitude),
                  //   zoom: 15,
                  //   bearing: 0,
                  //   tilt: 0,
                  // ),
                  rotationGesturesEnable: false,
                  indoorEnable: true,
                  locationButtonEnable: false,
                  consumeSymbolTapEvents: false,
                ),
                onMapReady: (controller) async {
                  mpaControllerCompleter.complete(controller);
                  log("건물주 네이버맵 준비완료!", name : "onMapReady");
                },
              ),
            ),
            //여기에 위젯 추가
            OutlinedButton(onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => const Owner(),
                  ),
                );
              }, child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('안내도 업로드\t', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 49, 49, 49))),
                    Icon(Icons.upload_file_outlined, color: Color.fromARGB(255, 49, 49, 49), size: 20),
                  ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}