import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/utils/utils.dart';

import 'package:fyp_project/widget/app_theme.dart';

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

  }

  cashOut() async {

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
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [AppTheme.primary, AppTheme.secondary])
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 60.0),
                    Text(
                      "Available Balance",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.4,
                        height: 0.9,
                        color: AppTheme.lightGrey,
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
                        color: AppTheme.white,
                      ),
                    ),
                  ],
                ),
              ),
              ),
            ),
            Positioned(
              top: 210,
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
                child: Text("hi"),
              ),
            ),
            Positioned(
              top: 160,
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
                                Icons.money_rounded,
                                size: 35,
                              ),
                              Text("Cash In"),
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
                                Icons.money,
                                size: 35,
                              ),
                              Text("Cash Out"),
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