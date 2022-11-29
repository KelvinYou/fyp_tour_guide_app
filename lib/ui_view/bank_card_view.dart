import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/ui_view/add_bank_card_view.dart';

import 'package:fyp_project/utils/app_theme.dart';

class BankCardView extends StatefulWidget {
  const BankCardView({super.key});

  @override
  State<BankCardView> createState() => _BankCardViewState();
}

class _BankCardViewState extends State<BankCardView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: AppBar(
        title: const Text('Bank Card'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBankCardView()),
          ),
              child: Text("Add")),
        ],
      ),
    );
  }

}