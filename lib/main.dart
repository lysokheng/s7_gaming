import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_game/controllers/controller.dart';
import 'package:new_game/views/s7_gaming.dart';

Future<void> main() async {
  afController.initAF();
  // Add this

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false, home: S7Gaming());
  }
}
