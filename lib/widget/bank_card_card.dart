import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:intl/intl.dart';

import 'package:fyp_project/ui_view/transaction_detail_view.dart';

class BankCardCard extends StatefulWidget {
  final snap;
  final int index;

  const BankCardCard({
    Key? key,
    required this.snap,
    required this.index,
  }) : super(key: key);

  @override
  State<BankCardCard> createState() => _BankCardCardState();
}

class _BankCardCardState extends State<BankCardCard> {
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
          AppTheme.backgroundLightGrey
          : AppTheme.backgroundNearlyWhite,
        borderRadius: BorderRadius.circular(0),
        // boxShadow: const [ AppTheme.boxShadow ],
      ),
      child: InkWell(
        // onTap: () => Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => TransactionDetail(
        //       transactionDetailSnap: widget.snap,
        //     ),
        //   ),
        // ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/800px-Mastercard-logo.svg.png',
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(width: 30.0),
                      Text(
                        "•••• •••• •••• ${widget.snap["cardNumber"].substring(
                            widget.snap["cardNumber"].length - 4
                        )}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),

                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
