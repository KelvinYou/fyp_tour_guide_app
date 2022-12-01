import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/ui_view/book_package_detail_view.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/ui_view/package_detail_view.dart';
import 'package:intl/intl.dart';

class BookPackageCard extends StatefulWidget {
  final snap;
  const BookPackageCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<BookPackageCard> createState() => _BookPackageCardState();
}

class _BookPackageCardState extends State<BookPackageCard> {
  @override
  void initState() {
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd MMM, H:mm');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
        color: AppTheme.nearlyWhite,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [ AppTheme.boxShadow ],
      ),
      child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BookPackageDetail(
                  bookPackageDetailSnap: widget.snap,
              ),
            ),
          ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Column(
            children: [
              Text("RM ${widget.snap["budget"]}"),
              Text("Waiting for accept"),
              Text(formatter.format(widget.snap["bookingDate"].toDate())),
              const SizedBox(height: 10.0),
              // Text(widget.snap["content"]),
            ],
          ),
        ),
      ),
    );
  }
}
