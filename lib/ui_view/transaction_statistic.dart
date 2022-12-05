import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/ui_view/transaction_history_view.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/loading_view.dart';
import 'package:fyp_project/widget/main_container.dart';
import 'package:fyp_project/widget/transaction_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TransactionStatisticView extends StatefulWidget {
  const TransactionStatisticView({super.key});

  @override
  State<TransactionStatisticView> createState() => _TransactionStatisticViewState();
}

class _TransactionStatisticViewState extends State<TransactionStatisticView> {
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

  Widget selectionView(IconData icon, String title) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 10.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),

              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
          title: "Transaction Statistic"
      ),
      body: isLoading? LoadingView() : Container(
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
                title: ChartTitle(text: "History Record"),
                backgroundColor: Theme.of(context).colorScheme.background,

                primaryXAxis: DateTimeAxis(
                  name: "Date"
                ),
                primaryYAxis: NumericAxis(
                  name: "RM"
                ),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  enableDoubleTapZooming: true,
                  enablePanning: true,
                  enableSelectionZooming: true,
                  enableMouseWheelZooming: true,
                  zoomMode: ZoomMode.x,
                  maximumZoomLevel: 0.01,
                ),
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
              const SizedBox(height: 20,),
              MainContainer(
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TransactionHistory(),
                            ),
                          ),
                          child: selectionView(Icons.area_chart, "Transaction History")
                      ),
                    ],
                  )
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
   this.newWalletBalance,
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
  final double? newWalletBalance;
  final DateTime? dateTime;
  final String? status;
}