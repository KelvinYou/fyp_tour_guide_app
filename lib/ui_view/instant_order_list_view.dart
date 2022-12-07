import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/order_request_card.dart';

class InstantOrderListView extends StatefulWidget {
  const InstantOrderListView({super.key});

  @override
  State<InstantOrderListView> createState() => _InstantOrderListViewState();
}

class _InstantOrderListViewState extends State<InstantOrderListView> {
  bool isLoading = false;
  String status = "Pending";
  var instantData = {};
  CollectionReference requestCollection =
  FirebaseFirestore.instance.collection('orderRequests');
  List<DocumentSnapshot> documents = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var instantSnap = await FirebaseFirestore.instance
          .collection('instantOrder')
          .doc("instant_${FirebaseAuth.instance.currentUser!.uid}")
          .get();

      instantData = instantSnap.data()!;

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

  Widget topBarSelection(String title) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          status = title;
        }),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: status == title ?
            Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.background,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: status == title ? Colors.white : Theme.of(context).colorScheme.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: SecondaryAppBar(
          title: "Instant Order List"
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    topBarSelection("Pending"),
                    topBarSelection("Accepted"),
                    topBarSelection("Rejected"),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: SizedBox(
                  height: double.infinity,
                  child: StreamBuilder(
                      stream: requestCollection
                          .orderBy('startTime', descending: false)
                          .snapshots(),
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          documents = streamSnapshot.data!.docs;
                          //todo Documents list added to filterTitle
                          documents = documents.where((element) {
                            return element
                                .get('status')
                                .contains(status);
                          }).toList();
                        }
                        return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (ctx, index) =>
                              Container(
                                child: OrderRequestCard(
                                  snap: documents[index].data(),
                                  index: index,
                                  tourGuideLatitude: instantData["currentLatitude"],
                                  tourGuideLongitude: instantData["currentLatitude"],
                                ),
                              ),
                        );
                      }
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }

}