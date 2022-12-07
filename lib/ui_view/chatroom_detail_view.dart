import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/message_card.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/text_field_input.dart';

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
  String touristName = '';

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
      var tourGuideSnap = await FirebaseFirestore.instance
          .collection('tourGuides')
          .doc(widget.chatroomDetailSnap["tourGuideId"])
          .get();

      var touristSnap = await FirebaseFirestore.instance
          .collection('tourists')
          .doc(widget.chatroomDetailSnap["touristId"])
          .get();

      setState(() {
        tourGuideName = tourGuideSnap.data()!["username"];
        touristName = touristSnap.data()!["username"];
      });
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
    if (contentController.text != "") {
      try {
        String res = await FireStoreMethods().sendMessage(
          widget.chatroomDetailSnap["chatroomId"],
          FirebaseAuth.instance.currentUser!.uid,
          // "Hello world",
          contentController.text,
          "text",
        );
        if (res == "success") {
          contentController.text = "";

          setState(() {
            isLoading = false;
          });
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
      appBar: SecondaryAppBar(
        title: widget.chatroomDetailSnap["chatroomTitle"]
      ),
      body: Container(
      // width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Divider(),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: StreamBuilder(
                  stream: messagesCollection
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
                    return ListView.builder(
                      reverse: true,
                      itemCount: documents.length,
                      itemBuilder: (ctx, index) =>
                          Container(
                            child: MessageCard(
                              snap: documents[index].data(),
                              touristName: touristName,
                              tourGuideName: tourGuideName,
                            ),
                          ),
                    );
                  }
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            decoration: BoxDecoration(
              // color: Theme.of(context).colorScheme.secondary,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 15,
                  child: TextFormField(
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.digitsOnly,
                    // ],
                    controller: contentController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write something ...',
                    ),
                    // maxLength: null,
                    maxLines: null,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    color: Theme.of(context).colorScheme.primary,
                    icon: Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

}