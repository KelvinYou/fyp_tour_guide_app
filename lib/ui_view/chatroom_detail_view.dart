import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/message_card.dart';

import 'package:intl/intl.dart';

import 'package:fyp_project/utils/app_theme.dart';

class ChatroomDetailView extends StatefulWidget {
  final chatroomDetailSnap;
  const ChatroomDetailView({super.key, required this.chatroomDetailSnap});
  @override
  State<ChatroomDetailView> createState() => _ChatroomDetailViewState();
}

class _ChatroomDetailViewState extends State<ChatroomDetailView> {
  TextEditingController contentController = TextEditingController();
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
        contentController = TextEditingController(text: "");

        setState(() {
          isLoading = false;
        });
        // showSnackBar(
        //   context,
        //   'Sent!',
        // );
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
    FocusManager.instance.primaryFocus?.unfocus();
  }

  CollectionReference messagesCollection =
  FirebaseFirestore.instance.collection('messages');
  List<DocumentSnapshot> documents = [];

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
          stream: messagesCollection
              // .where('chatroomId', isEqualTo: )
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.hasData) {
              documents = streamSnapshot.data!.docs;

              documents = documents.where((element) {
                return element
                    .get('chatroomId')
                    .contains(widget.chatroomDetailSnap["chatroomId"]);
              }).toList();
            }
            return Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 5.0,
                    child: ListView.builder(
                      reverse: true,
                      itemCount: documents.length,
                      itemBuilder: (ctx, index) =>
                        Container(
                          child: MessageCard(
                            snap: documents[index].data(),
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