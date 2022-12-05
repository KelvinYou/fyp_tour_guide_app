import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/ui_view/profile_setting_view.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/chatroom_card.dart';
import 'package:fyp_project/widget/app_bar/main_app_bar.dart';
import 'package:fyp_project/widget/loading_view.dart';

class ChatroomView extends StatefulWidget {
  const ChatroomView({super.key});

  @override
  State<ChatroomView> createState() => _ChatroomViewState();
}

class _ChatroomViewState extends State<ChatroomView> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // addChat();
  }

  addChat() async {
    try {
      String res = await FireStoreMethods().addChatroom(
        "Tourist 1",
        FirebaseAuth.instance.currentUser!.uid,
        "Name 1",
        "[No message]"
      );
      if (res == "success") {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Message"),
      body: isLoading ? LoadingView() : Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('chatrooms')
                    .orderBy('lastMessageTime', descending: true)
                // .where('tourGuideId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingView(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) =>
                        Container(
                          child: ChatroomCard(
                            snap: snapshot.data!.docs[index].data(),
                            index: index,
                          ),
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('chatrooms')
      //       .orderBy('lastMessageTime', descending: true)
      //   // .where('tourGuideId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      //       .snapshots(),
      //   builder: (context,
      //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     return Container(
      //       height: double.infinity,
      //       decoration: BoxDecoration(
      //         color: Theme.of(context).colorScheme.background,
      //       ),
      //       child: Column(
      //         children: [
      //           Expanded(
      //             child: SizedBox(
      //               height: 5.0,
      //               child: ListView.builder(
      //                 itemCount: snapshot.data!.docs.length,
      //                 itemBuilder: (ctx, index) =>
      //                     Container(
      //                       child: ChatroomCard(
      //                         snap: snapshot.data!.docs[index].data(),
      //                         index: index,
      //                       ),
      //                     ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // ),
    );
  }

}