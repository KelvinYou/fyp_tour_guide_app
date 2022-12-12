import 'dart:math';

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

class OrderRequestDetail extends StatefulWidget {
  final orderRequestDetailSnap;
  final double tourGuideLatitude;
  final double tourGuideLongitude;

  const OrderRequestDetail({
    super.key,
    required this.orderRequestDetailSnap,
    required this.tourGuideLongitude,
    required this.tourGuideLatitude,
  });

  @override
  State<OrderRequestDetail> createState() => _OrderRequestDetailState();
}

class _OrderRequestDetailState extends State<OrderRequestDetail> {
  bool isLoading = false;
  var instantData = {};
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

      var touristSnap = await FirebaseFirestore.instance
          .collection('tourists')
          .doc(widget.orderRequestDetailSnap["touristId"])
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
    final action = await Dialogs.yesAbortDialog(
        context, 'Confirm to "${responseType}"?',
        'Once confirmed, it cannot be modified anymore',
        responseType);

    if (action == DialogAction.yes) {
      try {
        _firestore.collection('orderRequests').doc(
            widget.orderRequestDetailSnap["orderId"]).update(
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
        "Instant Order Request",
        widget.orderRequestDetailSnap["tourGuideId"],
        widget.orderRequestDetailSnap["touristId"],
        "[no message]",
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });

        var chatroomSnap = await FirebaseFirestore.instance
            .collection('chatrooms')
            .doc("chatroom_${widget.orderRequestDetailSnap["tourGuideId"]}_${widget.orderRequestDetailSnap["touristId"]}")
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

  double _calculateDistance(double lat1, double lng1, lat2, lng2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    var distanceInKiloMeters = 12742 * asin(sqrt(a));

    /// return as distance in Meters
    return distanceInKiloMeters * 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        title: "Order Request Detail"
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

              detailRow("Tourist Current Address: ", widget.orderRequestDetailSnap["address"]),

              detailRow("Distance: ", widget.tourGuideLongitude != null
                  && widget.tourGuideLatitude != null?
              "${(_calculateDistance(widget.orderRequestDetailSnap["currentLatitude"],
                  widget.orderRequestDetailSnap["currentLatitude"], widget.tourGuideLatitude,
                  widget.tourGuideLongitude) / 1000)
                  .toStringAsFixed(3)} KM" : " "),

              detailRow("Payment: ", widget.orderRequestDetailSnap["isPaymentMade"] ?
              "Paid" : "Haven't Paid"),

              detailRow("Start Time: ", formatter.format(widget.orderRequestDetailSnap["startTime"].toDate())),

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
              widget.orderRequestDetailSnap["status"] != "Pending" ? SizedBox() : Container(
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