import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/ui_view/chatroom_detail_view.dart';
import 'package:fyp_project/ui_view/package_detail_view.dart';
import 'package:fyp_project/utils/utils.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:intl/intl.dart';

import 'package:fyp_project/ui_view/transaction_detail_view.dart';
import 'package:fyp_project/widget/loading_view.dart';

class MessageCard extends StatefulWidget {
  final snap;
  final String touristName;
  final String tourGuideName;

  const MessageCard({
    Key? key,
    required this.snap,
    required this.touristName,
    required this.tourGuideName,
  }) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  bool isLoading = false;
  var packageData = {};

  @override
  void initState() {
    super.initState();
    getPackageData();
  }

  getPackageData() async {
    setState(() {
      isLoading = true;
    });

    if (widget.snap["type"] == "package") {
      try {
        var packageSnap = await FirebaseFirestore.instance
            .collection('tourPackages')
            .doc(widget.snap["content"])
            .get();

        if (packageSnap.exists) {
          packageData = packageSnap.data()!;
        }

        setState(() {});
      } catch (e) {
        showSnackBar(
          context,
          e.toString(),
        );
      }

    }
    setState(() {
      isLoading = false;
    });
  }


  final DateFormat formatter = DateFormat('dd MMM, H:mm');

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width);
    bool isOwner = widget.snap["fromId"] == FirebaseAuth.instance.currentUser!.uid;


    return Container(
        width: width,
        alignment: isOwner ? Alignment.centerRight : Alignment.centerLeft,
        margin: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
        ),
        child: Column(
          crossAxisAlignment: isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isOwner ? widget.tourGuideName : widget.touristName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            widget.snap["type"] == "text" ? (
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
                  color: isOwner ? Colors.white :
                  Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ) ) : (
                packageData["packageTitle"] != null ?
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PackageDetail(
                      packageDetailSnap: packageData,
                    ),
                  ),
                ),
                child: Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: isOwner ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: packageData["photoUrl"] != null ? Image.network(

                          packageData["photoUrl"],) : SizedBox(),
                      ),
                      Text(
                        packageData["packageTitle"],
                        style: TextStyle(
                          color: isOwner ? Colors.white :
                          Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),

                    ],
                  ),
                )
              ) : Container(
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
                  "<This package may have been deleted by the tour guide>",
                  style: TextStyle(
                    color: isOwner ? Colors.white :
                    Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              )
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
    );
  }
}
