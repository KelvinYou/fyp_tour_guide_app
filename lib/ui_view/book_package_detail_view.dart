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
import 'package:intl/intl.dart';

class BookPackageDetail extends StatefulWidget {
  final bookPackageDetailSnap;
  const BookPackageDetail({super.key, required this.bookPackageDetailSnap});

  @override
  State<BookPackageDetail> createState() => _BookPackageDetailState();
}

class _BookPackageDetailState extends State<BookPackageDetail> {
  bool isLoading = false;
  var bookingData = {};
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
      var bookingSnap = await FirebaseFirestore.instance
          .collection('tourPackages')
          .doc(widget.bookPackageDetailSnap["packageId"])
          .get();

      bookingData = bookingSnap.data()!;

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

  delete() async {
    setState(() {
      isLoading = true;
    });

    String res = await FireStoreMethods().deletePackage(widget.bookPackageDetailSnap["bookingId"]);

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
        title: "Booking Detail"
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text("Budget: RM ${widget.bookPackageDetailSnap["budget"]}"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}