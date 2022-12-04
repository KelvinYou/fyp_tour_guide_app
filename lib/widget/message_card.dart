import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/ui_view/chatroom_detail_view.dart';
import 'package:fyp_project/utils/utils.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:intl/intl.dart';

import 'package:fyp_project/ui_view/transaction_detail_view.dart';

class MessageCard extends StatefulWidget {
  final snap;
  final String tourGuideName;

  const MessageCard({
    Key? key,
    required this.snap,
    required this.tourGuideName,
  }) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }



  final DateFormat formatter = DateFormat('dd MMM, H:mm');



  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width);
    bool isOwner = widget.snap["fromId"] == FirebaseAuth.instance.currentUser!.uid;

    return widget.snap["type"] == "text" ? Container(
        width: width,
        alignment: isOwner ? Alignment.centerRight : Alignment.centerLeft,
        margin: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          // color: AppTheme.darkText,
          // border: Border.all(color: Colors.white),
          // borderRadius: BorderRadius.circular(0),
          // boxShadow: const [ AppTheme.boxShadow ],
        ),
        child: Column(
          crossAxisAlignment: isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isOwner ? widget.tourGuideName : "Tourist name",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: isOwner ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.background,
                border: Border.all(color: isOwner ?
                  Theme.of(context).colorScheme.background
                  : Theme.of(context).colorScheme.primary
                ),
                borderRadius: BorderRadius.circular(5),
                // boxShadow: const [ AppTheme.boxShadow ],
              ),
              child: Text(
                widget.snap["content"],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              formatter.format(widget.snap["timestamp"].toDate()),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        )
    ) : (
      Container(

      )
    );
  }
}
