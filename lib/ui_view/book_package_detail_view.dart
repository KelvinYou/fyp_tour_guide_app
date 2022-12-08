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
import 'package:fyp_project/widget/dialogs.dart';
import 'package:fyp_project/widget/loading_view.dart';
import 'package:fyp_project/widget/package_card.dart';
import 'package:fyp_project/widget/person_card.dart';
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

  final DateFormat formatter = DateFormat('dd MMM y');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  responseBtn(String responseType) async {
    final action = await Dialogs.yesAbortDialog(
        context, 'Confirm to "${responseType}"?',
        'Once confirmed, it cannot be modified anymore',
        responseType);

    if (action == DialogAction.yes) {
      try {
        _firestore.collection('bookings').doc(
            widget.bookPackageDetailSnap["bookingId"]).update(
            {"status": responseType}
        );
        showSnackBar(context, responseType);
        Navigator.of(context).pop();
      } catch (err) {
        showSnackBar(context, err.toString());
      }
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

  int rowNum = 0;

  Widget detailRow(String title, String content) {
    setState(() {
      rowNum++;
    });

    return Container(
      decoration: BoxDecoration(
          color: rowNum % 2 == 1 ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.tertiaryContainer
      ),
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          SizedBox(width: 10,),
          Expanded(
            flex: 4,
            child: Text(title),
          ),
          Expanded(
            flex: 6,
            child: Text(content != "" ? content : "<No Data>"),
          ),
        ],
      ),
    );
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
              detailRow("Tour Date: ", formatter.format(widget.bookPackageDetailSnap["bookingDate"].toDate())),
              detailRow("Price: ", "RM ${widget.bookPackageDetailSnap["price"]}"),
              detailRow("Status: ", widget.bookPackageDetailSnap["status"]),
              detailRow("Payment: ", widget.bookPackageDetailSnap["isPaymentMade"] ? "Paid" : "Haven't Paid"),
              detailRow("Create By: ", formatter.format(widget.bookPackageDetailSnap["bookingDate"].toDate())),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "Request By: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              touristData.isEmpty ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text("The tourist may have been deleted"),
              ) : PersonCard(
                snap: touristData,
                index: 1,
              ),
              touristData.isEmpty ? SizedBox() : Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: ColoredButton(
                  onPressed: startChat,
                  childText: "Chat with Tourist",
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "Tour Package: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
              packageData.isEmpty ? widget.bookPackageDetailSnap["status"] != "Rejected" ?
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.0),
                width: MediaQuery. of(context). size. width,
                child: ColoredButton(
                    inverseColor: true,
                    onPressed: () => responseBtn("Rejected"),
                    childText: "Reject"),
              ) : SizedBox() :
              widget.bookPackageDetailSnap["status"] == "Pending" ? Container(
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
              ) : SizedBox(),

            ],
          ),
        ),
      ),
    );
  }
}