import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionRecord {
  final String transactionId;
  final double transactionAmount;
  final String ownerId;
  final String receiveFrom;
  final String transactionType;
  final String paymentDetails;
  final String paymentMethod;
  final DateTime dateTime;
  final String status;

  const TransactionRecord(
      {required this.transactionId,
        required this.transactionAmount,
        required this.ownerId,
        required this.receiveFrom,
        required this.transactionType,
        required this.paymentDetails,
        required this.paymentMethod,
        required this.dateTime,
        required this.status,
      });

  static TransactionRecord fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TransactionRecord(
      transactionId: snapshot["transactionId"],
      transactionAmount: snapshot["transactionAmount"],
      ownerId: snapshot["ownerId"],
      receiveFrom: snapshot["receiveFrom"],
      transactionType: snapshot["transactionType"],
      paymentDetails: snapshot["paymentDetails"],
      paymentMethod: snapshot["paymentMethod"],
      dateTime: snapshot["dateTime"],
      status:snapshot["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "transactionId": transactionId,
    "transactionAmount": transactionAmount,
    "ownerId": ownerId,
    "receiveFrom": receiveFrom,
    "transactionType": transactionType,
    "paymentDetails": paymentDetails,
    "paymentMethod": paymentMethod,
    "dateTime": dateTime,
    "status": status,
  };
}