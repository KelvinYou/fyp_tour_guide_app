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
    double width = (MediaQuery.of(context).size.width) - 52;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.nearlyWhite,
        border: Border.all(color: Colors.white),
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
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
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
            const Divider(
                color: Colors.black
            ),
          ],
        )
      ),
    );
  }
}
