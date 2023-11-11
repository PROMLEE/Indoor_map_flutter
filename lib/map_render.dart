import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({required this.marker, Key? key}) : super(key: key);
  final NMarker marker;

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '출발지, 도착지 설정',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: Text(
                '위도: ${widget.marker.position.latitude}\n경도: ${widget.marker.position.longitude}',
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
