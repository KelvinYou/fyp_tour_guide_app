import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/bottom_bar_view.dart';
import 'package:fyp_project/resources/firestore_methods.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/loading_view.dart';
import 'package:fyp_project/widget/text_field_input.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/utils/utils.dart';

class WithdrawView extends StatefulWidget {
  final String bankNum;
  const WithdrawView({
    required this.bankNum,
    super.key,
  });

  @override
  State<WithdrawView> createState() => _WithdrawViewState();
}

class _WithdrawViewState extends State<WithdrawView> {
  final withdrawController = TextEditingController();
  String withdrawErrorMsg = "";
  bool isLoading = false;
  var eWalletData = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var eWalletSnap = await FirebaseFirestore.instance
          .collection('eWallet')
          .doc("ewallet_${FirebaseAuth.instance.currentUser!.uid}")
          .get();

      eWalletData = eWalletSnap.data()!;

      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  submit() async {
    setState(() {
      isLoading = true;
      withdrawErrorMsg = "";
    });

    bool withdrawFormatCorrected = false;
    double withdrawAmount = 0;

    try {
      withdrawAmount = double.parse(withdrawController.text);
    } catch (err) {
      setState(() {
        withdrawErrorMsg = err.toString();
      });
    }

    if (withdrawController.text == "") {
      setState(() {
        withdrawErrorMsg = "Please enter the withdraw amount";
      });
    } else if (withdrawAmount < 1) {
      setState(() {
        withdrawErrorMsg = "The minimum withdraw amount is RM1";
      });
    } else if (withdrawAmount > eWalletData["balance"]) {
      setState(() {
        withdrawErrorMsg = "The maximum withdraw amount is RM${eWalletData["balance"].toStringAsFixed(2)}";
      });
    }else {
      withdrawFormatCorrected = true;
    }

    setState(() {
      isLoading = false;
    });

    if (withdrawFormatCorrected) {
      try {
        String res = await FireStoreMethods().withdrawEWallet(
          FirebaseAuth.instance.currentUser!.uid,
          withdrawAmount,
          widget.bankNum,
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
          showSnackBar(
            context,
            'Withdraw Successfully!',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
          title: "Withdraw"
      ),
      body: isLoading ? LoadingView() : Container(
      // width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          TextFieldInput(
            textEditingController: withdrawController,
            hintText: "Withdraw Amount: RM",
            textInputType: TextInputType.number,
            iconData: Icons.attach_money,
            errorMsg: withdrawErrorMsg,
          ),
          Text("Available amount for withdraw: RM${eWalletData["balance"].toStringAsFixed(2)}"),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: ColoredButton(onPressed: submit, childText: "Withdraw"),
          ),
        ],
      ),
      ),
    );
  }

}