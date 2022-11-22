import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/widget/app_theme.dart';

class TransactionDetail extends StatefulWidget {
  final transactionDetailSnap;
  const TransactionDetail({super.key, required this.transactionDetailSnap});
  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Details'),
      ),
      body: ListView(
        children: [
          Text("TransactionType: ${widget.transactionDetailSnap["receiveFrom"]}"),
        ],
      ),
    );
  }

}