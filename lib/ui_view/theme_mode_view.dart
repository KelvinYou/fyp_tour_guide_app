import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/utils/themeChoice.dart';

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
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Theme Mode'),
      ),
      body: ThemeChoice(),
    );
  }

}