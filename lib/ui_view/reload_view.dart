import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/bottom_bar_view.dart';
import 'package:fyp_project/resources/firestore_methods.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/text_field_input.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/utils/utils.dart';

class ReloadView extends StatefulWidget {
  const ReloadView({super.key});

  @override
  State<ReloadView> createState() => _ReloadViewState();
}

class _ReloadViewState extends State<ReloadView> {
  final reloadController = TextEditingController();
  String reloadErrorMsg = "";
  bool isLoading = false;

  submit() async {
    setState(() {
      isLoading = true;
      reloadErrorMsg = "";
    });

    bool reloadFormatCorrected = false;
    double reloadAmount = 0;

    try {
      reloadAmount = double.parse(reloadController.text);
    } catch (err) {
      setState(() {
        reloadErrorMsg = err.toString();
      });
    }

    if (reloadController.text == "") {
      setState(() {
        reloadErrorMsg = "Please enter the reload amount";
      });
    } else if (reloadAmount < 10) {
      setState(() {
        reloadErrorMsg = "The minimum reload amount is RM10";
      });
    } else {
      reloadFormatCorrected = true;
    }

    setState(() {
      isLoading = false;
    });

    if (reloadFormatCorrected) {
      try {
        String res = await FireStoreMethods().reloadEWallet(
          FirebaseAuth.instance.currentUser!.uid,
          reloadAmount,
        );
        if (res == "success") {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BottomBarView(selectedIndex: 2),
            ), (Route<dynamic> route) => false,
          );
          showSnackBar(context, "Reload successfully");
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
          title: "Reload"
      ),
      body: Container(
        // width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFieldInput(
              textEditingController: reloadController,
              hintText: "Reload Amount: RM",
              textInputType: TextInputType.number,
              iconData: Icons.attach_money,
              errorMsg: reloadErrorMsg,
            ),
            Text("Min reload amount is RM10"),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: ColoredButton(onPressed: submit, childText: "Reload eWallet"),
            ),
          ],
        ),
      ),
    );
  }

}