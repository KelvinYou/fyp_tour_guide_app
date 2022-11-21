import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/widget/app_theme.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  bool isLoading = false;

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
      body: ListView(
        children: [
          Text("tiada"),
        ],
      ),
    );
  }

}