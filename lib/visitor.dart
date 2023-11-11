import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class NaverMapApp extends StatelessWidget {
  const NaverMapApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Completer<NaverMapController> mapControllerCompleter = Completer();
    final marker = NMarker(
        id: 'currentPosition',
        position: const NLatLng(37.50315317166826, 126.9556528096827));
    final onMarkerInfoWindow =
        NInfoWindow.onMarker(id: marker.info.id, text: "중앙대 310관");
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(30),
                  child: const Text("실내\n길 찾기.",
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
                  // initialCameraPosition: NCameraPosition(
                  //   target: NLatLng(marker.position.latitude,marker.position.longitude),
                  //   zoom: 15,
                  //   bearing: 0,
                  //   tilt: 0,
                  // ),
                  rotationGesturesEnable: false,
                  indoorEnable: true,
                  locationButtonEnable: true,
                  consumeSymbolTapEvents: false,
                ),
                onMapReady: (controller) async {
                  mapControllerCompleter.complete(controller);
                  log("방문객 네이버맵 준비완료!", name : "onMapReady");
                  controller.addOverlay(marker);
                  marker.openInfoWindow(onMarkerInfoWindow);
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
