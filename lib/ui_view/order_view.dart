import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/ui_view/book_history_view.dart';
import 'package:fyp_project/ui_view/instant_history_view.dart';
import 'package:fyp_project/ui_view/instant_order_list_view.dart';
import 'package:fyp_project/ui_view/package_booking_list_view.dart';
import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/app_bar/main_app_bar.dart';
import 'package:fyp_project/widget/dialogs.dart';
import 'package:fyp_project/widget/main_container.dart';
import 'package:fyp_project/widget/loading_view.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  bool isLoading = false;
  List<Object> bookingData = <Object>[];
  List<Object> instantData = <Object>[];

  @override
  void initState() {
    super.initState();
    getDataFromFireStore();
  }

  Future<void> getDataFromFireStore() async {
    setState(() {
      isLoading = true;
    });
    var bookingSnapShotsValue =
      await FirebaseFirestore.instance.collection("bookings")
      .where("tourGuideId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where("status", isEqualTo: "Pending")
      .get();

    List<Object> bookList = bookingSnapShotsValue.docs
        .map((e) => Object()).toList();

    var instantSnapShotsValue =
    await FirebaseFirestore.instance.collection("orderRequests")
        .where("tourGuideId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("status", isEqualTo: "Pending")
        .get();

    List<Object> instantList = instantSnapShotsValue.docs
        .map((e) => Object()).toList();

    setState(() {
      bookingData = bookList;
      instantData = instantList;
      isLoading = false;
    });
  }

  Widget topCountNum(String title, int number) {
    return Expanded(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Column(
            children: [
              Text(
                number.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ]
          ),
        ),
    );
  }

  Widget selectionView(IconData icon, String title) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 10.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),

              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Order"),
      body: isLoading ? LoadingView() : Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              const SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    topCountNum("Booking Pending", bookingData.length),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const SizedBox(height: 20,),
              MainContainer(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        "Booking Received",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const InstantOrderListView(),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text("Instant Order"),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 12,
                                child: Text(
                                  instantData.length.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                        color: AppTheme.lightGrey,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PackageBookingListView(),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text("Tour Package Order"),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 12,
                                child: Text(
                                  bookingData.length.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              MainContainer(
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            final action = await Dialogs.selectionAbortDialog(
                                context, '', '',
                                'Instant Order', 'Tour Package');
                            if (action == DialogSelection.first) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const BookHistoryView(),
                                ),
                              );
                            } else if (action == DialogSelection.second) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const InstantHistoryView(),
                                ),
                              );
                            }
                          },
                          child: selectionView(Icons.history, "History")
                      ),
                    ],
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }

}