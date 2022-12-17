import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_project/ui_view/user_detail_view.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/ui_view/package_detail_view.dart';
import 'package:fyp_project/widget/image_full_screen.dart';
import 'package:intl/intl.dart';

class PersonCard extends StatefulWidget {
  final snap;
  final int index;
  final String role;
  const PersonCard({
    Key? key,
    required this.snap,
    required this.index,
    this.role = "Tour Guide",
  }) : super(key: key);

  @override
  State<PersonCard> createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  @override
  void initState() {
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd MMM y');

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      decoration: BoxDecoration(
        color: widget.index % 2 == 0 ?
        Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.tertiaryContainer,
      ),
      child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserDetail(
                snap: widget.snap,
                role: widget.role,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 36.0,
                    backgroundImage: NetworkImage(
                      widget.snap["photoUrl"],
                    ),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      SizedBox(height: 5.0),
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
                            widget.snap['rating'].toString(),
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onPrimary
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Icons.chevron_right),
            ],
          )
      ),
    );
  }
}
