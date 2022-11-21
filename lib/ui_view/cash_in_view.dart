import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/bottom_bar_view.dart';
import 'package:fyp_project/resources/firestore_methods.dart';

import 'package:fyp_project/widget/app_theme.dart';
import 'package:fyp_project/widget/text_field_input.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/utils/utils.dart';

class CashIn extends StatefulWidget {
  const CashIn({super.key});

  @override
  State<CashIn> createState() => _CashInState();
}

class _CashInState extends State<CashIn> {
  final reloadController = TextEditingController();
  bool isLoading = false;

  submit() async {
    setState(() {
      isLoading = true;
    });

    double amount = double.parse(reloadController.text);

    try {
      String res = await FireStoreMethods().reloadEWallet(
        FirebaseAuth.instance.currentUser!.uid,
        amount,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const BottomBarView(selectedIndex: 2),
            )
        );
        showSnackBar(
          context,
          'Reload Successfully!',
        );
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
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Reload'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text("RM"),
          const SizedBox(height: 5),
          TextFieldInput(
              textEditingController: reloadController,
              hintText: "",
              textInputType: TextInputType.number),
          Text("Min reload amount is RM10"),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: submit, child: Text("Reload eWallet")),
        ],
      ),
    );
  }

}