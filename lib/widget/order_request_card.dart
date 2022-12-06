import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/ui_view/book_package_detail_view.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/ui_view/package_detail_view.dart';
import 'package:intl/intl.dart';

class OrderRequestCard extends StatefulWidget {
  final snap;
  final int index;
  const OrderRequestCard({
    Key? key,
    required this.snap,
    required this.index,
  }) : super(key: key);

  @override
  State<OrderRequestCard> createState() => _OrderRequestCardState();
}

class _OrderRequestCardState extends State<OrderRequestCard> {
  @override
  void initState() {
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd MMM, H:mm');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: widget.index % 2 == 0 ?
        Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.tertiaryContainer,
      ),
      child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BookPackageDetail(
                  bookPackageDetailSnap: widget.snap,
              ),
            ),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "${widget.index + 1}. Instant Order Request",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(width: 15,),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0),
                      Text("Payment"),
                      const SizedBox(height: 10.0),
                      Text("Start Time"),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0),
                      Text(widget.snap["isPaymentMade"] ? "Paid" : "Haven't paid"),
                      const SizedBox(height: 10.0),
                      Text(formatter.format(widget.snap["startTime"].toDate())),
                      // Text(widget.snap["content"]),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right),
                SizedBox(width: 15,),
              ],
            ),
          ],
        )
      ),
    );
  }
}
