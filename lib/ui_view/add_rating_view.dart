import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/resources/firestore_methods.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/loading_view.dart';
import 'package:fyp_project/widget/text_field_input.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

class AddRatingView extends StatefulWidget {
  final snap;
  const AddRatingView({
    super.key,
    required this.snap,
  });

  @override
  State<AddRatingView> createState() => _AddRatingViewState();
}

class _AddRatingViewState extends State<AddRatingView> {
  bool isLoading = false;
  var feedbackData = {};
  int feedbackRating = 0;
  String contentErrorMsg = "";

  TextEditingController contentController = TextEditingController();

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
      if (widget.snap["bookingId"] != null) {
        var feedbackSnap = await FirebaseFirestore.instance
            .collection('feedbacks')
            .doc("feedback_${widget.snap["bookingId"]}_${widget.snap["tourGuideId"]}")
            .get();
        if(feedbackSnap.exists) {
          feedbackData = feedbackSnap.data()!;
          feedbackRating = feedbackSnap["rating"].toInt();
          contentController = TextEditingController(text: feedbackData["content"]);
        }
      }

      if (widget.snap["orderId"] != null) {
        var feedbackSnap = await FirebaseFirestore.instance
            .collection('feedbacks')
            .doc("feedback_${widget.snap["orderId"]}_${widget.snap["tourGuideId"]}")
            .get();
        if(feedbackSnap.exists) {
          feedbackData = feedbackSnap.data()!;
          feedbackRating = feedbackSnap["rating"].toInt();
          contentController = TextEditingController(text: feedbackData["content"]);
        }
      }


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

  addFeedBack() async {
    setState(() {
      isLoading = true;
    });

    try {
      String res = await FireStoreMethods().addFeedback(
        widget.snap["orderId"] != null ? widget.snap["orderId"] : widget.snap["bookingId"],
        widget.snap["tourGuideId"],
        widget.snap["touristId"],
        feedbackRating.toDouble(),
        contentController.text,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
        showSnackBar(
          context,
          'Submitted!',
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  Widget ratingRow() {
    double rating = feedbackRating.toDouble();

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text("Rating"),
        ),
        Expanded(
          flex: 4,
          child: RatingBar.builder(
            initialRating: rating,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 24.0,
            direction: Axis.horizontal,
            onRatingUpdate: (rating) {
              setState(() {
                feedbackRating = rating.toInt();
              });
            },
          ),
        ),
        Text(
          rating.toInt().toString(),
          style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onPrimary
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
          title: "Feedback"
      ),
      body: isLoading ? LoadingView() : Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: ratingRow(),
                  ),
                  const SizedBox(height: 20),
                  TextFieldInput(
                    textEditingController: contentController,
                    hintText: "Content",
                    textInputType: TextInputType.text,
                    maxLines: null,
                    errorMsg: contentErrorMsg,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                    child: ColoredButton(
                        onPressed: addFeedBack,
                        childText: "Submit"
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}