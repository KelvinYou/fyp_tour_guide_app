import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/sender_message_card.dart';

import 'package:intl/intl.dart';

import 'package:fyp_project/widget/app_theme.dart';

class ChatroomDetailView extends StatefulWidget {
  final chatroomDetailSnap;
  const ChatroomDetailView({super.key, required this.chatroomDetailSnap});
  @override
  State<ChatroomDetailView> createState() => _ChatroomDetailViewState();
}

class _ChatroomDetailViewState extends State<ChatroomDetailView> {
  final contentController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // addMessage();
  }

  addMessage() async {
    try {
      String res = await FireStoreMethods().sendMessage(
        widget.chatroomDetailSnap["chatroomId"],
        FirebaseAuth.instance.currentUser!.uid,
        contentController.text,
        "text"
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: Text(widget.chatroomDetailSnap["chatroomTitle"]),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('messages')
              .where('chatroomId', isEqualTo: widget.chatroomDetailSnap["chatroomId"]).snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 5.0,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) =>
                          Container(
                            child: SenderMessageCard(
                              snap: snapshot.data!.docs[index].data(),
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
    );
  }

}