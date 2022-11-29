import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/ui_view/tour_package_view.dart';
import 'package:fyp_project/utils/utils.dart';

import 'package:fyp_project/utils/app_theme.dart';
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

  final DateFormat formatter = DateFormat('dd MMM, H:mm');

  List<String> questions = [
    'You can lead a cow down stairs but not up stairs.',
    'Approximately one quarter of human bones are in the feet.',
    'A slug\'s blood is green.'
  ];
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.packageDetailSnap["packageType"].length,
              itemBuilder: (context, index) {
                return Text('${widget.packageDetailSnap["packageType"][index]}');
              },
            ),
          ),
          Expanded(
            flex: 9,

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  // Expanded(
                  //   child: ElevatedButton(
                  //     onPressed: delete,
                  //     child: Text("Edit"),
                  //   ),
                  // ),
                  // SizedBox(width: 20,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: delete,
                      child: Text("Delete"),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}