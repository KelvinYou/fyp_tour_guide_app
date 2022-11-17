import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/widget/app_theme.dart';

class ChangeProfile extends StatefulWidget {
  const ChangeProfile({super.key});

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Change Profile'),
      ),
      body: Text("Change Profile"),
    );
  }
}