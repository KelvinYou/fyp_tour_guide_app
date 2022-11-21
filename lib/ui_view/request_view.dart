import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      body: ListView(
        children: [
          Text("tiada request"),
        ],
      ),
    );
  }

}