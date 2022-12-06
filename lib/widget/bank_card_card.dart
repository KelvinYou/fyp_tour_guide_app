import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/resources/firestore_methods.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/dialogs.dart';
import 'package:intl/intl.dart';

import 'package:fyp_project/ui_view/transaction_detail_view.dart';

class BankCardCard extends StatefulWidget {
  final snap;
  final int index;
  final String? reloadOrWithdraw;

  const BankCardCard({
    Key? key,
    required this.snap,
    required this.index,
    this.reloadOrWithdraw,
  }) : super(key: key);

  @override
  State<BankCardCard> createState() => _BankCardCardState();
}

class _BankCardCardState extends State<BankCardCard> {
  @override
  void initState() {
    super.initState();
  }


  delete() async {
    String res = await FireStoreMethods().deleteBankCard(widget.snap["cardId"]);

    if (res == "success") {
      showSnackBar(context, "Bank card removed successfully");
    } else {
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width) - 52;

    return Container(
      decoration: BoxDecoration(
        color: widget.index % 2 == 0 ?
          Theme.of(context).colorScheme.secondaryContainer
          : Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/800px-Mastercard-logo.svg.png',
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(width: 30.0),
                    Text(
                      "•••• •••• •••• ${widget.snap["cardNumber"].substring(
                          widget.snap["cardNumber"].length - 4
                      )}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      final action = await Dialogs.yesAbortDialog(
                      context, 'Confirm to delete?', '',
                      'Delete');
                      if (action == DialogAction.yes) {
                        delete();
                      }
                    },
                    icon: Icon(CupertinoIcons.trash),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
