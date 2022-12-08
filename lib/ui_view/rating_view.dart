import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/loading_view.dart';
import 'package:fyp_project/widget/feedback_card.dart';

class RatingView extends StatefulWidget {
  const RatingView({super.key});

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  bool isLoading = false;
  String status = "My Reviews";
  String rateByGuide = "My Reviews";
  String rateByTourist = "Tourist Rating";

  CollectionReference ratingCollection =
  FirebaseFirestore.instance.collection('feedbacks');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
          title: "Rating"
      ),
      body: isLoading? LoadingView() : Container(
        width: double.infinity,
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
                  topBarSelection(rateByGuide),
                  topBarSelection(rateByTourist),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: StreamBuilder(
                    stream: ratingCollection
                        // .orderBy('tourDate', descending: false)
                        .snapshots(),
                    builder: (context, streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        documents = streamSnapshot.data!.docs;
                        //todo Documents list added to filterTitle
                        documents = documents.where((element) {
                          return element
                              .get(status == rateByGuide ? 'fromId' : 'toId')
                              .contains(FirebaseAuth.instance.currentUser!.uid);
                        }).toList();
                      }
                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (ctx, index) =>
                            Container(
                              child: FeedbackCard(
                                snap: documents[index].data(),
                                index: index,
                                fromTourist: status == rateByGuide ? false : true,
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