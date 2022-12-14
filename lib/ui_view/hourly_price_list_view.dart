import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/book_package_card.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/instant_order_card.dart';
import 'package:fyp_project/widget/main_container.dart';
import 'package:fyp_project/widget/loading_view.dart';

class HourlyPriceListView extends StatefulWidget {
  const HourlyPriceListView({super.key});

  @override
  State<HourlyPriceListView> createState() => _HourlyPriceListViewState();
}

class _HourlyPriceListViewState extends State<HourlyPriceListView> {
  bool isLoading = false;
  bool isDescending = true;
  CollectionReference instantOrderCollection =
  FirebaseFirestore.instance.collection('instantOrder');
  List<DocumentSnapshot> documents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
          title: "Price List Of Guide"
      ),
      body: isLoading ? LoadingView() : Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          children: [
            // GestureDetector(
            //   onTap: () => setState(() {
            //     isDescending = !isDescending;
            //   }),
            //   child: Container(
            //     padding: EdgeInsets.symmetric(vertical: 5),
            //     decoration: BoxDecoration(
            //       color: Theme.of(context).colorScheme.primary,
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(
            //           isDescending ? "Latest on Top" : "Earliest on Top",
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 16,
            //           ),
            //         ),
            //         SizedBox(width: 10,),
            //         Icon(
            //           isDescending ? Icons.arrow_upward
            //               : Icons.arrow_downward,
            //           color: Colors.white,
            //           size: 16,
            //         ),
            //       ],
            //
            //     ),
            //   ),
            // ),
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: StreamBuilder(
                    stream: instantOrderCollection
                        .orderBy('price', descending: isDescending)
                        .snapshots(),
                    builder: (context, streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        documents = streamSnapshot.data!.docs;
                        //todo Documents list added to filterTitle
                        // documents = documents.where((element) {
                        //   return element
                        //       .get('status')
                        //       .contains(status);
                        // }).toList();
                      }
                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (ctx, index) =>
                            Container(
                              child: InstantOrderCard(
                                snap: documents[index].data(),
                                index: index,
                              ),
                            ),
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}