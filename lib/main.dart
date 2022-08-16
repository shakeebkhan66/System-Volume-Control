import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:office_detection_sound_task/volume_control_page.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VolumeControlScreen(),
    );
  }
}
