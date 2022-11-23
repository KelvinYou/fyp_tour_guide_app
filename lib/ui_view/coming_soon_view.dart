import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ComingSoonView extends StatefulWidget {
  const ComingSoonView({super.key});

  @override
  State<ComingSoonView> createState() => _ComingSoonViewState();
}

class _ComingSoonViewState extends State<ComingSoonView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      body: ListView(
        children: [
          Center(
            child: Text("Coming Soon ..."),
          ),
        ],
      ),
    );
  }

}