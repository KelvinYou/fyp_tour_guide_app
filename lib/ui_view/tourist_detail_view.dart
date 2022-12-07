import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/ui_view/share_to_view.dart';
import 'package:fyp_project/ui_view/tour_package_view.dart';
import 'package:fyp_project/utils/utils.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:intl/intl.dart';
import 'package:fyp_project/widget/image_full_screen.dart';

class TouristDetail extends StatefulWidget {
  final touristDetailSnap;
  const TouristDetail({
    super.key,
    required this.touristDetailSnap,
  });

  @override
  State<TouristDetail> createState() => _TouristDetailState();
}

class _TouristDetailState extends State<TouristDetail> {
  bool isLoading = false;
  List<String> selectedTypes = [];

  Widget getTextWidgets(List<String> strings)
  {
    List<Widget> list = <Widget>[];
    for(var i = 0; i < strings.length; i++){
      list.add(new Text(strings[i]));
    }
    return new Row(children: list);
  }

  final DateFormat formatter = DateFormat('dd MMM y');

  Widget splitView(String title, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(title),
          ),
          Expanded(
            flex: 6,
            child: Text(content),
          ),
        ],
      ),
    );
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
    return isLoading
      ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: SecondaryAppBar(
        title: "Tourist Detail",
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15,),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return ImageFullScreen(imageUrl: widget.touristDetailSnap["photoUrl"],);
                  }));
                },
                child: Center(
                  child: CircleAvatar(
                    radius: 56.0,
                    backgroundImage: NetworkImage(
                      widget.touristDetailSnap["photoUrl"],
                    ),
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBarIndicator(
                    rating: widget.touristDetailSnap['rating'],
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 24.0,
                    direction: Axis.horizontal,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    widget.touristDetailSnap['rating'].toString(),
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimary
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              const Text(" Tourist Details"),
              const Divider(),
              detailRow("Username:", widget.touristDetailSnap["username"]),
              detailRow("Full name:", widget.touristDetailSnap["fullname"]),
              detailRow("Email:", widget.touristDetailSnap["email"]),
              detailRow("Phone Number:", widget.touristDetailSnap["phoneNumber"]),
              detailRow("Description:", widget.touristDetailSnap["description"]),

            ],
          ),
        ),
      ),
    );
  }
}
