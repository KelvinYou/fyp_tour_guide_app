import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:fyp_project/app_theme.dart';
import 'package:fyp_project/bottom_bar_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // Future<FirebaseApp> _initializeFirebase() async {
  //   FirebaseApp firebaseApp = await Firebase.initializeApp();
  //   return firebaseApp;
  // }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Tour Guide App",
      home: BottomBarView(),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: FutureBuilder(
  //       future: _initializeFirebase(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           return const BottomBarView();
  //         }
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }
  //     )
  //   );
  // }
  // }
}



