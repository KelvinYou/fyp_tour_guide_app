import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text("tiada message"),
        ],
      ),
    );
  }

}