import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fyp_project/widget/app_theme.dart';
import 'package:intl/intl.dart';

import 'package:fyp_project/ui_view/transaction_detail_view.dart';

class TransactionCard extends StatefulWidget {
  final snap;
  const TransactionCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  void initState() {
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd MMM, H:mm');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.nearlyWhite,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(0),
        boxShadow: const [ AppTheme.boxShadow ],
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TransactionDetail(
              transactionDetailSnap: widget.snap,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(widget.snap["receiveFrom"]),
                  const SizedBox(height: 10.0),
                  Text(widget.snap["paymentMethod"]),
                ],
              ),
              Row(
                children: [
                  Text(widget.snap["transactionAmount"]),
                  const SizedBox(height: 10.0),
                  Text(formatter.format(widget.snap["dateTime"].toDate())),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
