import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/ui_view/chatroom_detail_view.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:intl/intl.dart';

import 'package:fyp_project/ui_view/transaction_detail_view.dart';

class ChatroomCard extends StatefulWidget {
  final snap;
  final int index;
  final VoidCallback? function;

  const ChatroomCard({
    Key? key,
    required this.snap,
    this.index = 0,
    this.function,
  }) : super(key: key);

  @override
  State<ChatroomCard> createState() => _ChatroomCardState();
}

class _ChatroomCardState extends State<ChatroomCard> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd MMM, H:mm');

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width) - 52;

    return widget.snap["tourGuideId"] != FirebaseAuth.instance.currentUser!.uid ? Container(

    ) : Container(
      decoration: BoxDecoration(
        color: widget.index % 2 == 0 ?
        Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.tertiaryContainer,
        // border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(0),
        // boxShadow: const [ AppTheme.boxShadow ],
      ),
      child: InkWell(
        onTap: widget.function != null ?
          widget.function
          : () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatroomDetailView(
              chatroomDetailSnap: widget.snap,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.snap["chatroomTitle"],
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: width * 0.6,
                    child: Text(
                      widget.snap["lastMessage"],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.4,
                    child: Text(
                      formatter.format(widget.snap["lastMessageTime"].toDate()),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),

            ],
          ),
        ),
      ),
    );
  }
}
