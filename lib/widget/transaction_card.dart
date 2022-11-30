import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:intl/intl.dart';

import 'package:fyp_project/ui_view/transaction_detail_view.dart';

class TransactionCard extends StatefulWidget {
  final snap;
  final int index;

  const TransactionCard({
    Key? key,
    required this.snap,
    required this.index,
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
    double width = (MediaQuery.of(context).size.width) - 52;

    return Container(
      decoration: BoxDecoration(
        color: widget.index % 2 == 0 ?
        AppTheme.backgroundLightGrey : AppTheme.backgroundNearlyWhite,
        borderRadius: BorderRadius.circular(0),
        // boxShadow: const [ AppTheme.boxShadow ],
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TransactionDetail(
              transactionDetailSnap: widget.snap,
            ),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 15,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.5,
                        child: Text(
                          widget.snap["receiveFrom"],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: AppTheme.lightText,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.5,
                        child: Text(
                          widget.snap["transactionAmount"],
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.5,
                        child: Text(
                          widget.snap["paymentMethod"],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: AppTheme.lightText,
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.5,
                        child: Text(
                          formatter.format(widget.snap["dateTime"].toDate()),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
