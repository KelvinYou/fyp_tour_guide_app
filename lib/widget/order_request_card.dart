import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/ui_view/book_package_detail_view.dart';
import 'package:fyp_project/ui_view/order_request_detail_view.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/ui_view/package_detail_view.dart';
import 'package:intl/intl.dart';

class OrderRequestCard extends StatefulWidget {
  final snap;
  final int index;
  final double? tourGuideLongitude;
  final double? tourGuideLatitude;
  const OrderRequestCard({
    Key? key,
    required this.snap,
    required this.index,
    this.tourGuideLongitude,
    this.tourGuideLatitude,
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

  double _calculateDistance(double lat1, double lng1, lat2, lng2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    var distanceInKiloMeters = 12742 * asin(sqrt(a));

    /// return as distance in Meters
    return distanceInKiloMeters * 1000;
  }

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
              builder: (context) => OrderRequestDetail(
                  orderRequestDetailSnap: widget.snap,
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
                      const SizedBox(height: 10.0),
                      Text(
                        widget.tourGuideLongitude != null
                          && widget.tourGuideLatitude != null?
                        "${(_calculateDistance(widget.snap["currentLatitude"],
                        widget.snap["currentLatitude"], widget.tourGuideLatitude,
                        widget.tourGuideLongitude) / 1000)
                            .toStringAsFixed(3)} KM" : " "
                      ),
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
                      const SizedBox(height: 10.0),

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
