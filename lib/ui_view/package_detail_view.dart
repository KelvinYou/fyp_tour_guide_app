import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/ui_view/tour_package_view.dart';
import 'package:fyp_project/utils/utils.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:intl/intl.dart';

class PackageDetail extends StatefulWidget {
  final packageDetailSnap;
  const PackageDetail({super.key, required this.packageDetailSnap});

  @override
  State<PackageDetail> createState() => _PackageDetailState();
}

class _PackageDetailState extends State<PackageDetail> {
  bool isLoading = false;
  List<String> selectedTypes = [];

  delete() async {
    setState(() {
      isLoading = true;
    });

    String res = await FireStoreMethods().deletePackage(widget.packageDetailSnap["packageId"]);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
      showSnackBar(context, "Package removed successfully");
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  final DateFormat formatter = DateFormat('dd MMM, H:mm');

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: SecondaryAppBar(
        title: widget.packageDetailSnap["packageTitle"]
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text("Type(s): ${
                widget.packageDetailSnap["packageType"]
                  .reduce((value, element) => value + ', ' + element)
              }"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text("Content: ${widget.packageDetailSnap["content"]}"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text("Duration: ${widget.packageDetailSnap["duration"].toString()} days"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Image(
                width: double.infinity - 20,
                image: NetworkImage( widget.packageDetailSnap["photoUrl"]),
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text("Create Date: ${formatter.format(widget.packageDetailSnap["createDate"].toDate())}"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text("Last Modify Date: ${formatter.format(widget.packageDetailSnap["lastModifyDate"].toDate())}"),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: ColoredButton(
                onPressed: delete,
                childText: "Delete",
              ),
            ),

          ],
        ),
      ),
    );
  }
}