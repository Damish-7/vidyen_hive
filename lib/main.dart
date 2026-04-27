import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidyen_hive/screens/login_screen.dart';
import 'package:vidyen_hive/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vidyen_Hive',
      theme: ThemeData(
       // colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      
    );
  }
}

