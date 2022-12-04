import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';

import 'package:intl/intl.dart';

import 'package:fyp_project/utils/app_theme.dart';

class TransactionDetail extends StatefulWidget {
  final transactionDetailSnap;
  const TransactionDetail({super.key, required this.transactionDetailSnap});
  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  bool isLoading = false;

  Widget cardView(String title, String content) {
    double width = (MediaQuery.of(context).size.width) - 50;

    return Column(
      children: [
        Container(
          // height: 100,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              SizedBox(
                width: width * 0.4,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.6,
                child: Text(
                  content,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    // fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),

        const Divider(
            color: Colors.black
        ),
      ],
    );
  }

  final DateFormat formatter = DateFormat('dd MMM, H:mm');

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: SecondaryAppBar(
          title: "Details"
      ),
      body: Container(
      // width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                widget.transactionDetailSnap["transactionAmount"],
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            const Divider( color: Colors.black ),
            cardView("Transaction Type", widget.transactionDetailSnap["transactionType"]),
            cardView("Receive From", widget.transactionDetailSnap["receiveFrom"]),
            cardView("Payment Details", widget.transactionDetailSnap["paymentDetails"]),
            cardView("Payment Method", widget.transactionDetailSnap["paymentMethod"]),
            cardView("Date/Time", formatter.format(widget.transactionDetailSnap["dateTime"].toDate())),
            cardView("Status", widget.transactionDetailSnap["status"]),
            cardView("Transaction No.", widget.transactionDetailSnap["transactionId"]),
          ],
        ),
      ),),
    );
  }

}