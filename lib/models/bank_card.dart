import 'package:cloud_firestore/cloud_firestore.dart';

class BankCard {
  final String cardId;
  final String ownerId;
  final int cardNumber;
  final int ccv;
  final int cardHolder;

  const BankCard(
      {required this.cardId,
        required this.ownerId,
        required this.cardNumber,
        required this.ccv,
        required this.cardHolder,
      });

  static BankCard fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return BankCard(
      cardId: snapshot["cardId"],
      ownerId: snapshot["ownerId"],
      cardNumber: snapshot["cardNumber"],
      ccv: snapshot["ccv"],
      cardHolder: snapshot["cardHolder"],
    );
  }

  Map<String, dynamic> toJson() => {
    "cardId": cardId,
    "ownerId": ownerId,
    "cardNumber": cardNumber,
    "ccv": ccv,
    "cardHolder": cardHolder,
  };
}