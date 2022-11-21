import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/ui_view/tour_package_view.dart';
import 'package:fyp_project/utils/utils.dart';

import 'package:fyp_project/widget/app_theme.dart';

class PackageDetail extends StatefulWidget {
  final packageDetailSnap;
  const PackageDetail({super.key, required this.packageDetailSnap});

  @override
  State<PackageDetail> createState() => _PackageDetailState();
}

class _PackageDetailState extends State<PackageDetail> {
  bool isLoading = false;

  delete() async {
    setState(() {
      isLoading = true;
    });

    String res = await FireStoreMethods().deletePackage(widget.packageDetailSnap["packageId"]);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const TourPackage()
          ), (route) => false);
      showSnackBar(context, "Package removed successfully");
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text(widget.packageDetailSnap["packageTitle"]),
      ),
      body: Column(
        children: [
          Text("Content: ${widget.packageDetailSnap["content"]}"),
          Text("Type: ${widget.packageDetailSnap["packageType"]}"),
          ElevatedButton(onPressed: delete, child: Text("delete")),
        ],
      ),
    );
  }
}