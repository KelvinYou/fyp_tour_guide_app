import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/ui_view/tourist_detail_view.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/ui_view/package_detail_view.dart';
import 'package:fyp_project/widget/image_full_screen.dart';
import 'package:intl/intl.dart';

class TouristCard extends StatefulWidget {
  final snap;
  final int index;
  const TouristCard({
    Key? key,
    required this.snap,
    required this.index,
  }) : super(key: key);

  @override
  State<TouristCard> createState() => _TouristCardState();
}

class _TouristCardState extends State<TouristCard> {
  @override
  void initState() {
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd MMM y');

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: widget.index % 2 == 0 ?
        Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.tertiaryContainer,
      ),
      child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TouristDetail(
                touristDetailSnap: widget.snap,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(widget.snap["username"]),
            ],
          )
      ),
    );
  }
}
