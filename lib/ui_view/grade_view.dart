import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';

class GradeView extends StatefulWidget {
  const GradeView({super.key});

  @override
  State<GradeView> createState() => _GradeViewState();
}

class _GradeViewState extends State<GradeView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: SecondaryAppBar(
          title: "Grade"
      ),
      body: Text("Coming soon. pls wait for announcement.."),
    );
  }

}