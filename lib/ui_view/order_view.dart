import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/widget/app_bar/main_app_bar.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: MainAppBar(title: "Order"),
      body: Column(
        children: [
          Text("waiting for teammate"),
        ],
      ),
    );
  }

}