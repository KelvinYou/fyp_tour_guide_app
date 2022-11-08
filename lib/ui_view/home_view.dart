import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const String title = 'Home';
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(title), ),
    );
  }
}