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
import 'package:fyp_project/widget/person_card.dart';
import 'package:intl/intl.dart';

class OrderRequestDetail extends StatefulWidget {
  final orderRequestDetailSnap;
  const OrderRequestDetail({super.key, required this.orderRequestDetailSnap});

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