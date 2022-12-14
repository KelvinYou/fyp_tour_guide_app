import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:fyp_project/utils/app_theme.dart';

import 'package:fyp_project/ui_view/home_view.dart';
import 'package:fyp_project/ui_view/order_view.dart';
import 'package:fyp_project/ui_view/wallet_view.dart';
import 'package:fyp_project/ui_view/chatroom_view.dart';
import 'package:fyp_project/ui_view/profile_view.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomBarView extends StatefulWidget {
  final int selectedIndex;
  const BottomBarView({super.key, required this.selectedIndex});

  @override
  State<BottomBarView> createState() => _MyBottomBarView();
}

class _MyBottomBarView extends State<BottomBarView> {

  int _selectedIndex = 0;

  @override
  void initState() {
    setState(() {
      _selectedIndex = widget.selectedIndex;
    });
  }

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
    ChatroomView(),
    Profile(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page_outlined),
            activeIcon: Icon(Icons.request_page),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: AppTheme.primary,
        onTap: _onItemTapped,
      ),

    );
  }
}
