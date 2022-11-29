import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';

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
      appBar: AppBar(
        title: const Text('Coming Soon'),
      ),
      body: Text("Coming soon. pls wait for announcement.."),
    );
  }

}