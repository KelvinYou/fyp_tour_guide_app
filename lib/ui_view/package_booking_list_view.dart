import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/book_package_card.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/main_container.dart';
import 'package:fyp_project/widget/loading_view.dart';

class PackageBookingListView extends StatefulWidget {
  const PackageBookingListView({super.key});

  @override
  State<PackageBookingListView> createState() => _PackageBookingListViewState();
}

class _PackageBookingListViewState extends State<PackageBookingListView> {
  bool isLoading = false;
  String status = "Pending";
  CollectionReference bookingCollection =
  FirebaseFirestore.instance.collection('booking');
  List<DocumentSnapshot> documents = [];

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
          title: "Tour Package Booking List"
      ),
      body: isLoading ? LoadingView() : Container(
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
                    stream: bookingCollection
                        .orderBy('tourDate', descending: false)
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
                              child: BookPackageCard(
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
      ),
    );
  }

}