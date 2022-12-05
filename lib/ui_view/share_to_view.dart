import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/chatroom_card.dart';
import 'package:fyp_project/widget/dialogs.dart';
import 'package:fyp_project/widget/loading_view.dart';

class ShareToView extends StatefulWidget {
  final snap;
  const ShareToView({
    super.key,
    required this.snap,
  });

  @override
  State<ShareToView> createState() => _ShareToViewState();
}

class _ShareToViewState extends State<ShareToView> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  share(String chatroomId) async {
    try {
      String res = await FireStoreMethods().sendMessage(
        chatroomId,
        FirebaseAuth.instance.currentUser!.uid,
        // "Hello world",
        widget.snap["packageId"],
        "package",
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
    FocusManager.instance.primaryFocus?.unfocus();
  }

  shareToConfirmation(String chatroomId) async {
    final action = await Dialogs.yesAbortDialog(
        context, 'Confirm to share?', 'Once confirmed, this package details will be sent to the chatroom',
        'Share');
    if (action == DialogAction.yes) {
      share(chatroomId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: "Share To .. "),
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
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) =>
                        Container(
                          child: ChatroomCard(
                            snap: snapshot.data!.docs[index].data(),
                            index: index,
                            function: () => shareToConfirmation(
                                snapshot.data!.docs[index].data()["chatroomId"]
                            ),
                          ),
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}