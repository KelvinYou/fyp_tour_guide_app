import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/widget/app_theme.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      body: ListView(
        children: [
          Text("tiada message"),
        ],
      ),
    );
  }

}