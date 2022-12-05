import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WalletStatisticView extends StatefulWidget {
  const WalletStatisticView({super.key});

  @override
  State<WalletStatisticView> createState() => _WalletStatisticViewState();
}

class _WalletStatisticViewState extends State<WalletStatisticView> {
  bool isLoading = false;

  //Holds the data source of chart
  List<_TransactionData> transactionData = <_TransactionData>[];

  @override
  void initState() {
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    print("aisdin");
    setState(() {
      isLoading = true;
    });
    var snapShotsValue =
    await FirebaseFirestore.instance.collection("transactions")
        .orderBy('dateTime', descending: false).get();

    List<_TransactionData> list = snapShotsValue.docs
      .map((e) => _TransactionData(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
      e.data()['dateTime'].millisecondsSinceEpoch),
      transactionAmount: e.data()['transactionAmount']
    )).toList();
    setState(() {
      transactionData = list;
      isLoading = false;
    });
    print(transactionData);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: SecondaryAppBar(
          title: "Wallet Statistic"
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                primaryYAxis: NumericAxis(),
                series: <ChartSeries<_TransactionData, DateTime>>[
                  LineSeries<_TransactionData, DateTime>(
                    dataSource: transactionData,
                    xValueMapper: (_TransactionData data, _) => data.dateTime,
                    yValueMapper: (_TransactionData data, _) =>
                    double.parse(
                        data.transactionAmount!.substring(0, 1)
                            + data.transactionAmount!.substring(4)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _TransactionData {
  _TransactionData({
   this.transactionId,
   this.transactionAmount,
   this.ownerId,
   this.receiveFrom,
   this.transactionType,
   this.paymentDetails,
   this.paymentMethod,
   this.dateTime,
   this.status,
  });
  final String? transactionId;
  final String? transactionAmount;
  final String? ownerId;
  final String? receiveFrom;
  final String? transactionType;
  final String? paymentDetails;
  final String? paymentMethod;
  final DateTime? dateTime;
  final String? status;
}
