import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/utils/themeChoice.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';

class ThemeModeView extends StatefulWidget {
  const ThemeModeView({super.key});

  @override
  State<ThemeModeView> createState() => _ThemeModeViewState();
}

class _ThemeModeViewState extends State<ThemeModeView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: SecondaryAppBar(
          title: "Theme Mode"
      ),
      body: ThemeChoice(),
    );
  }

}