import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/ui_view/add_bank_card_view.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/bank_card_card.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/loading_view.dart';

class BankCardView extends StatefulWidget {
  const BankCardView({super.key});

  @override
  State<BankCardView> createState() => _BankCardViewState();
}

class _BankCardViewState extends State<BankCardView> {
  bool isLoading = false;

  CollectionReference bankCardsCollection =
  FirebaseFirestore.instance.collection('bankCards');
  List<DocumentSnapshot> documents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
          title: "Bank Cards"
      ),
      body: isLoading ? LoadingView() : Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: ColoredButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddBankCardView()),
                ),
                childText: "Add",
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: const Divider(
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: AppTheme.lightGrey,
              ),
            ),
            Center(
              child: Text(
                "My Bank Cards",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: StreamBuilder(
                stream: bankCardsCollection.snapshots(),
                builder: (context, streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    documents = streamSnapshot.data!.docs;

                    documents = documents.where((element) {
                      return element
                          .get('ownerId')
                          .contains(FirebaseAuth.instance.currentUser!.uid);
                    }).toList();
                  }
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (ctx, index) =>
                      Container(
                        child: BankCardCard(
                          snap: documents[index].data(),
                          index: index,
                        ),
                      ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: const Divider(
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: AppTheme.lightGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

}