import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/widget/app_theme.dart';

import 'package:fyp_project/ui_view/add_package_view.dart';

class TourPackage extends StatefulWidget {
  const TourPackage({super.key});

  @override
  State<TourPackage> createState() => _TourPackageState();
}

class _TourPackageState extends State<TourPackage> {
  void addPackage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPackage()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Tour Package'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: addPackage,
            style: ElevatedButton.styleFrom(
              primary: AppTheme.nearlyWhite,
              side: const BorderSide(width: 1.0, color: AppTheme.primary,),
            ),
            child: const Text(
              'Add',
              style: TextStyle(
                color: AppTheme.primary,
              ),
            ),
          ),
          Text("hello2"),
          Text("hello3"),
        ],
      ),
    );
  }
}