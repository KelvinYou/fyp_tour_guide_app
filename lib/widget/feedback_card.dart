import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_project/ui_view/rating_detail_view.dart';
import 'package:fyp_project/ui_view/user_detail_view.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/ui_view/package_detail_view.dart';
import 'package:fyp_project/widget/image_full_screen.dart';
import 'package:intl/intl.dart';

class FeedbackCard extends StatefulWidget {
  final snap;
  final int index;
  final bool fromTourist;
  const FeedbackCard({
    Key? key,
    required this.snap,
    required this.index,
    required this.fromTourist,
  }) : super(key: key);

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  @override
  void initState() {
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd MMM y');

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: widget.index % 2 == 0 ?
        Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.tertiaryContainer,
      ),
      child: InkWell(
          // onTap: () => Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => UserDetail(
          //       snap: widget.snap,
          //       role: "Tour Guide",
          //     ),
          //   ),
          // ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RatingDetailView(
                snap: widget.snap,
                fromTourist: widget.fromTourist,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: widget.snap['rating'].toDouble(),
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
                          '${widget.snap['rating'].toInt().toString()} Stars' ,
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onPrimary
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.snap["content"],

                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right),
              ),

            ],
          )
      ),
    );
  }
}
