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
import 'package:fyp_project/widget/loading_view.dart';
import 'package:fyp_project/widget/package_card.dart';
import 'package:fyp_project/widget/tourist_card.dart';
import 'package:intl/intl.dart';

class BookPackageDetail extends StatefulWidget {
  final bookPackageDetailSnap;
  const BookPackageDetail({super.key, required this.bookPackageDetailSnap});

  @override
  State<BookPackageDetail> createState() => _BookPackageDetailState();
}

class _BookPackageDetailState extends State<BookPackageDetail> {
  bool isLoading = false;
  var packageData = {};
  var touristData = {};

  List<String> selectedTypes = [];

  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var packageSnap = await FirebaseFirestore.instance
          .collection('tourPackages')
          .doc(widget.bookPackageDetailSnap["packageId"])
          .get();

      packageData = packageSnap.data()!;

      var touristSnap = await FirebaseFirestore.instance
          .collection('tourists')
          .doc(widget.bookPackageDetailSnap["touristId"])
          .get();

      touristData = touristSnap.data()!;

      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  final DateFormat formatter = DateFormat('dd MMM, H:mm');

  responseBtn(String responseType) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        title: "Booking Detail"
      ),
      body: isLoading ? LoadingView() : Container(
        // width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),
              TouristCard(
                snap: touristData,
                index: 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),
              PackageCard(
                snap: packageData,
                index: 0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.0),
                width: MediaQuery. of(context). size. width,
                child: Row(
                  children: [
                    Expanded(child: ColoredButton(
                        onPressed: () => responseBtn("Reject"),
                        childText: "Reject"),
                    ),
                    SizedBox(width: 20,),
                    Expanded(child: ColoredButton(
                        onPressed: () => responseBtn("Accept"),
                        childText: "Accept"),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}