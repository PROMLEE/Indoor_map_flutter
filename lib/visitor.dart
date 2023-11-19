import 'dart:async';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:navermaptest01/map_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NaverMapApp extends StatefulWidget {
  const NaverMapApp({Key? key}) : super(key: key);

  @override
  State<NaverMapApp> createState() => _NaverMapAppState();
}

class _NaverMapAppState extends State<NaverMapApp> {
  String uid = FirebaseAuth.instance.currentUser!.uid; //현재 파이어베이스에 로그인되어있는 uid
//서버에서 가져오는 시간이 있으니까 async랑 await을 써줘야함
  getUserInfo() async {
    var result = await FirebaseFirestore.instance
        .collection("36705604")
        .doc("VvYL2K0517jsE1TXoLAv")
        .get();
    return result.data();
  }

//DB에서 가져온 데이터를 보여줄때는 FutureBuilder나 StreamBuilder를 사용해야함
//StreamBuilder는 데이터가 지속적으로 변해야할때 사용
//FutureBuilder는 한번만 가져오면 될때 사용
//그러면 우리는 좌표만 딱 해서 하면되니까 FutureBuilder사용
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
              child: FutureBuilder(
                future: getUserInfo(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //가져온 데이터는 snapshot에 저장되어있음
                  //snapshot은 object타입이라 바로 접근 불가
                  //따라서 Map으로 변환
                  log("홀리뱅$snapshot");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error: 데이터를 가져오는 데 실패했습니다.'));
                  } else {
                    var data = snapshot.data;
                    // 데이터를 사용하여 NaverMap 위젯을 구성합니다.
                    return snapshot.hasData
                        ? //데이터 가져오는데 시간이 걸리니까 빌드속도보다 느리면 null이라서 hasData키워드 사용
                        NaverMap(
                            options: const NaverMapViewOptions(
                              rotationGesturesEnable: false,
                              indoorEnable: true,
                              locationButtonEnable: true,
                              consumeSymbolTapEvents: false,
                            ),
                            onMapReady: (controller) async {
                              final iconImage = await NOverlayImage.fromWidget(
                                  widget:
                                      const Icon(Icons.other_houses_outlined),
                                  size: const Size(48, 48),
                                  context: context);
                              final marker1 = NMarker(
                                  id: "icon_test",
                                  position: const NLatLng(
                                      37.50315317166826, 126.9556528096827),
                                  icon: iconImage);
                              final marker2 = NMarker(
                                  id: "icon_test2",
                                  position: const NLatLng(
                                      37.656502569446545, 127.06337221344113),
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
                                      builder: (context) =>
                                          ThirdScreen(marker: marker),
                                    ),
                                  );
                                },
                              );
                              marker2.setOnTapListener(
                                (NMarker marker) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ThirdScreen(marker: marker),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : const Center(child: CircularProgressIndicator());
                  }
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
