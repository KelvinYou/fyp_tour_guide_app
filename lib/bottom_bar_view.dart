import 'dart:math' as math;

import 'package:fyp_project/main.dart';
import 'package:fyp_project/app_theme.dart';

import 'package:fyp_project/ui_view/home_view.dart';
import 'package:fyp_project/ui_view/request_view.dart';
import 'package:fyp_project/ui_view/wallet_view.dart';
import 'package:fyp_project/ui_view/message_view.dart';
import 'package:fyp_project/ui_view/profile_view.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({super.key});

  @override
  State<BottomBarView> createState() => _MyBottomBarView();
}

class _MyBottomBarView extends State<BottomBarView> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Request(),
    Wallet(),
    Message(),
    Profile(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
        // title: Center (
        //   child: _widgettitles.elementAt(_selectedIndex),
        // )
      // ),
      body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: AppTheme.secondary,
        selectedItemColor: AppTheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
