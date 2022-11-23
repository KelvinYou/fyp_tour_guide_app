import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/message_card.dart';

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
  String tourGuideName = '';

  @override
  void initState() {
    super.initState();
    // sendMessage();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('tourGuides')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      tourGuideName = userSnap.data()!['username'];

      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  sendMessage() async {
    try {
      String res = await FireStoreMethods().sendMessage(
        widget.chatroomDetailSnap["chatroomId"],
        FirebaseAuth.instance.currentUser!.uid,
        // "Hello world",
        contentController.text,
        "text",
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Sent!',
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
              // .where('chatroomId', isEqualTo: widget.chatroomDetailSnap["chatroomId"])
              .orderBy('timestamp', descending: false)
              .snapshots(),
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
                            child: MessageCard(
                              snap: snapshot.data!.docs[index].data(),
                              chatroomSnap: widget.chatroomDetailSnap,
                              tourGuideName: tourGuideName,
                            ),
                          ),
                    ),
                  ),
                ),
                TextField(
                  controller: contentController,
                ),
                ElevatedButton(onPressed: sendMessage, child: Text("Send"))
              ],
            );
          },
        ),
    );
  }

}