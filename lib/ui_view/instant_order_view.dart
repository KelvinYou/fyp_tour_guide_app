import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/app_theme.dart';

class InstantOrder extends StatefulWidget {
  const InstantOrder({super.key});

  @override
  State<InstantOrder> createState() => _InstantOrderState();
}

class _InstantOrderState extends State<InstantOrder> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Hourly Order'),
      ),
      body: Text("hello"),
    );
  }
}