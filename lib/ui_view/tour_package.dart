import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/app_theme.dart';

class TourPackage extends StatefulWidget {
  const TourPackage({super.key});

  @override
  State<TourPackage> createState() => _TourPackageState();
}

class _TourPackageState extends State<TourPackage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Tour Package'),
      ),
      body: Text("hello"),
    );
  }
}