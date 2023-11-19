import 'dart:async';
import 'dart:developer';
import 'package:navermaptest01/map_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class NaverMapApp extends StatelessWidget {
  const NaverMapApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Completer<NaverMapController> mapControllerCompleter = Completer();
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 15),
                  child: const Text(
                    "실내\n길 찾기.\n건물을 선택하세요.",
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
              child: NaverMap(
                options: const NaverMapViewOptions(
                  rotationGesturesEnable: false,
                  indoorEnable: true,
                  locationButtonEnable: true,
                  consumeSymbolTapEvents: false,
                ),
                onMapReady: (controller) async {
                  final iconImage = await NOverlayImage.fromWidget(
                      widget: const Icon(Icons.other_houses_outlined),
                      size: const Size(48, 48),
                      context: context);
                  final marker1 = NMarker(
                      id: "icon_test",
                      position:
                          const NLatLng(37.50315317166826, 126.9556528096827),
                      icon: iconImage);
                  final marker2 = NMarker(
                      id: "icon_test2",
                      position:
                          const NLatLng(37.656502569446545, 127.06337221344113),
                      icon: iconImage);
                  final markers = {marker1, marker2};
                  mapControllerCompleter.complete(controller);
                  log("방문객 네이버맵 준비완료!", name: "onMapReady");
                  controller.addOverlayAll(markers);
                  marker1.setOnTapListener(
                    (NMarker marker) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThirdScreen(marker: marker),
                        ),
                      );
                    },
                  );
                  marker2.setOnTapListener(
                    (NMarker marker) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThirdScreen(marker: marker),
                        ),
                      );
                    },
                  );
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
