import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidyen_hive/screens/auth/login_screen.dart';
import 'package:vidyen_hive/screens/home/home_screen.dart';
import 'package:vidyen_hive/screens/splash/splash_screen.dart';

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
      
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashScreen(),
          transition: Transition.fade,
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}

