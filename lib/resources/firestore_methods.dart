import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_project/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import 'package:fyp_project/models/tour_package.dart';
import 'package:fyp_project/models/instant_order.dart';
import 'package:fyp_project/models/e_wallet.dart';
import 'package:fyp_project/models/bank_card.dart';
class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tour Package
  Future<String> addPackage(String uid, String content, String packageType, int duration) async {
    String res = "Some error occurred";
    String packageId = const Uuid().v1();
    try {
      TourPackage tourPackage = TourPackage(
        packageId: packageId,
        ownerId: uid,
        packageType: packageType,
        content: content,
        duration: duration,
      );
      _firestore.collection('tourPackages').doc(packageId).set(tourPackage.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updatePackage(String packageId, String uid, String content, String packageType, int duration) async {
    String res = "Some error occurred";
    try {
      TourPackage tourPackage = TourPackage(
        packageId: packageId,
        ownerId: uid,
        packageType: packageType,
        content: content,
        duration: duration,
      );
      _firestore.collection('tourPackages').doc(packageId).set(tourPackage.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //haven't test
  Future<String> deletePackage(String packageId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('tourPackages').doc(packageId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Instant Order
  Future<String> updateOrder(String uid, int price, bool onDuty) async {
    String res = "Some error occurred";
    String orderID = "instant_$uid";
    try {
      InstantOrder instantOrder = InstantOrder(
        orderID: orderID,
        ownerID: uid,
        price: price,
        onDuty: onDuty,
      );
      _firestore.collection('instantOrder').doc(orderID).set(instantOrder.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // E Wallet
  Future<String> updateEWallet(String uid, double balance) async {
    String res = "Some error occurred";
    String eWalletId = "ewallet_$uid";
    try {
      EWallet eWallet = EWallet(
        eWalletId: eWalletId,
        ownerId: uid,
        balance: balance,
      );
      _firestore.collection('eWallet').doc(eWalletId).set(eWallet.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Bank Card
  //haven't test
  Future<String> bankCard(String uid, int cardNumber, int ccv, int cardHolder) async {
    String res = "Some error occurred";
    String cardId = const Uuid().v1();
    try {
      BankCard bankCard = BankCard(
        cardId: cardId,
        ownerId: uid,
        cardNumber: cardNumber,
        ccv: ccv,
        cardHolder: cardHolder,
      );
      _firestore.collection('bankCard').doc(cardId).set(bankCard.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
