import 'package:cloud_firestore/cloud_firestore.dart';

class InstantOrder {
  final String orderID;
  final String ownerID;
  final int price;
  final bool onDuty;

  const InstantOrder(
      {required this.orderID,
        required this.ownerID,
        required this.price,
        required this.onDuty,
      });

  static InstantOrder fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return InstantOrder(
      orderID: snapshot["orderID"],
      ownerID: snapshot["ownerID"],
      price: snapshot["price"],
      onDuty: snapshot["onDuty"],
    );
  }

  Map<String, dynamic> toJson() => {
    "orderID": orderID,
    "ownerID": ownerID,
    "price": price,
    "onDuty": onDuty,
  };
}