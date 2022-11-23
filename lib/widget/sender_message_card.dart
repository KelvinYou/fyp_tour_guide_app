import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/ui_view/chatroom_detail_view.dart';

import 'package:fyp_project/widget/app_theme.dart';
import 'package:intl/intl.dart';

import 'package:fyp_project/ui_view/transaction_detail_view.dart';

class SenderMessageCard extends StatefulWidget {
  final snap;
  const SenderMessageCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<SenderMessageCard> createState() => _SenderMessageCardState();
}

class _SenderMessageCardState extends State<SenderMessageCard> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd MMM, H:mm');

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width);

    return Container(
      width: width,
      alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        // color: AppTheme.darkText,
        // border: Border.all(color: Colors.white),
        // borderRadius: BorderRadius.circular(0),
        // boxShadow: const [ AppTheme.boxShadow ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
              // boxShadow: const [ AppTheme.boxShadow ],
            ),
            child: Text(
              widget.snap["content"],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            formatter.format(widget.snap["timestamp"].toDate()),
            style: TextStyle(
              color: AppTheme.lightText,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ],
      )
    );
  }
}
