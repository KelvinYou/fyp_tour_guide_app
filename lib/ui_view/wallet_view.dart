import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/ui_view/bank_card_view.dart';
import 'package:fyp_project/ui_view/reload_view.dart';
import 'package:fyp_project/ui_view/withdraw_view.dart';
import 'package:fyp_project/ui_view/transaction_history_view.dart';
import 'package:fyp_project/utils/utils.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/main_app_bar.dart';


class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
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

  cashIn() async {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ReloadView(),
        )
    );
  }

  cashOut() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WithdrawView(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return isLoading
      ? const Center(
        child: CircularProgressIndicator(),
      )
      : Scaffold(
        appBar: MainAppBar(title: "Wallet"),
        body: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
            ),
            Positioned(
              child: Container(
              height: 250,
              padding: EdgeInsets.symmetric(),
              decoration: BoxDecoration(
                color: AppTheme.secondary
                  // gradient: LinearGradient(
                  //     begin: Alignment.centerLeft,
                  //     end: Alignment.centerRight,
                  //     colors: [AppTheme.primary, AppTheme.secondary])
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 30.0),
                    Text(
                      "Available Balance",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.4,
                        height: 0.9,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "RM ${eWalletData["balance"].toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        letterSpacing: 0.4,
                        height: 0.9,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              ),
            ),
            Positioned(
              top: 180,
              child: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: AppTheme.nearlyWhite,
                  border: Border.all(color: Colors.white),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
              ),
            ),
            Positioned(
              top: 120,
              child: Container(
                height: 100,
                width: width * 0.9,
                margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: AppTheme.nearlyWhite,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [ AppTheme.boxShadow ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: cashIn,
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.attach_money_sharp,
                                size: 35,
                              ),
                              Text("Reload"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: cashOut,
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.money_off,
                                size: 35,
                              ),
                              Text("Withdraw"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TransactionHistory(),
                            )
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                size: 35,
                              ),
                              Text("History"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      );
  }
  
}