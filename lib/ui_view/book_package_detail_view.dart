import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/ui_view/chatroom_detail_view.dart';
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
  var chatroomData = {};

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

      if (packageSnap.exists) {
        packageData = packageSnap.data()!;
      }

      var touristSnap = await FirebaseFirestore.instance
          .collection('tourists')
          .doc(widget.bookPackageDetailSnap["touristId"])
          .get();

      if (touristSnap.exists) {
        touristData = touristSnap.data()!;
      }

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  responseBtn(String responseType) async {
    try {
      _firestore.collection('booking').doc(
          widget.bookPackageDetailSnap["bookingId"]).update(
          {"status": responseType}
      );
      showSnackBar(context, responseType);
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  startChat() async {
    try {
      String res = await FireStoreMethods().addChatroom(
        "Booking ${packageData["packageTitle"]}",
        widget.bookPackageDetailSnap["tourGuideId"],
        widget.bookPackageDetailSnap["touristId"],
        "[no message]",
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });

        var chatroomSnap = await FirebaseFirestore.instance
            .collection('chatrooms')
            .doc("chatroom_${widget.bookPackageDetailSnap["tourGuideId"]}_${widget.bookPackageDetailSnap["touristId"]}")
            .get();

        chatroomData = chatroomSnap.data()!;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatroomDetailView(
                chatroomDetailSnap: chatroomData
            ),
          ),
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {

      showSnackBar(
        context,
        err.toString(),
      );
    }
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
              touristData.isEmpty ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text("The tourist may have been deleted"),
              ) : TouristCard(
                snap: touristData,
                index: 1,
              ),
              touristData.isEmpty ? SizedBox() : Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: ColoredButton(
                  onPressed: startChat,
                  childText: "Start a chat",
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),
              packageData.isEmpty ?
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text("Package may have been deleted"),
                )
                : PackageCard(
                snap: packageData,
                index: 0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),
              packageData.isEmpty ? SizedBox() : Container(
                margin: EdgeInsets.symmetric(horizontal: 25.0),
                width: MediaQuery. of(context). size. width,
                child: Row(
                  children: [
                    Expanded(child: ColoredButton(
                      inverseColor: true,
                      onPressed: () => responseBtn("Rejected"),
                      childText: "Reject"),
                    ),
                    SizedBox(width: 20,),
                    Expanded(child: ColoredButton(
                        onPressed: () => responseBtn("Accepted"),
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