import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/app_theme.dart';

class InstantOrder extends StatefulWidget {
  const InstantOrder({super.key});

  @override
  State<InstantOrder> createState() => _InstantOrderState();
}

class _InstantOrderState extends State<InstantOrder> {
  final priceController = TextEditingController();
  bool editable = false;

  void edit() async {
    setState(() {
      editable = !editable;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Hourly Order'),
      ),
      body: ListView(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("On duty")),
          Text("Price"),
          TextField(
            enabled: editable,
            controller: priceController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Price',
            ),
          ),
          ElevatedButton(
              onPressed: () => edit(),
              child: Text("Edit")),
        ],
      ),
    );
  }
}