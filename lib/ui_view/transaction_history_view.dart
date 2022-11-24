import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/widget/app_theme.dart';
import 'package:fyp_project/widget/transaction_card.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  bool isLoading = false;

  CollectionReference transactionsCollection =
  FirebaseFirestore.instance.collection('transactions');
  List<DocumentSnapshot> documents = [];

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('History'),
      ),
      body: StreamBuilder(
        stream: transactionsCollection
          .orderBy('dateTime', descending: true)
          .snapshots(),
        builder: (context, streamSnapshot) {
          // if (streamSnapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          if (streamSnapshot.hasData) {
            documents = streamSnapshot.data!.docs;
            //todo Documents list added to filterTitle

            documents = documents.where((element) {
              return element
                  .get('ownerId')
                  .contains(FirebaseAuth.instance.currentUser!.uid);
            }).toList();
          }
          return Column(
            children: [
              Expanded(
                child: SizedBox(
                  height: 5.0,
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (ctx, index) =>
                      Container(
                        child: TransactionCard(
                          snap: documents[index].data(),
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