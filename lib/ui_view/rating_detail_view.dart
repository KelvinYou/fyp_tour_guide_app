import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_project/utils/utils.dart';

import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/loading_view.dart';
import 'package:fyp_project/widget/main_container.dart';
import 'package:fyp_project/widget/person_card.dart';
import 'package:intl/intl.dart';

class RatingDetailView extends StatefulWidget {
  final snap;
  final bool fromTourist;
  const RatingDetailView({
    super.key,
    required this.snap,
    required this.fromTourist,
  });

  @override
  State<RatingDetailView> createState() => _RatingDetailViewState();
}

class _RatingDetailViewState extends State<RatingDetailView> {
  bool isLoading = false;
  var personData = {};

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
      var personSnap = await FirebaseFirestore.instance
          .collection('tourists')
          .doc(widget.fromTourist ? widget.snap["fromId"] : widget.snap["toId"])
          .get();

      if (personSnap.exists) {
        setState(() {
          personData = personSnap.data()!;

        });
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

  final DateFormat formatter = DateFormat('dd MMM y');

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
          title: "Rating Detail"
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
              Center(
                child: RatingBarIndicator(
                  rating: widget.snap['rating'].toDouble(),
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 24.0,
                  direction: Axis.horizontal,
                ),
              ),
              const SizedBox(height: 5,),
              Center(
                child: Text(
                  '${widget.snap['rating'].toInt().toString()} Stars' ,
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onPrimary
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              MainContainer(
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      Center(
                        child: Text(
                          "< Content >",
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Center(
                        child: Text(
                          widget.snap["content"],
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onPrimary
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                    ],
                  )
              ),
              const SizedBox(height: 20,),
              detailRow("Rating Date: ", formatter.format(widget.snap["feedbackDate"].toDate())),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  widget.fromTourist ? "Rate By: " : "Rate To: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              PersonCard(
                  snap: personData,
                  index: 1
              ),

            ],
          ),
        ),
      ),
    );
  }
}