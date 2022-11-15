import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_project/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import 'package:fyp_project/models/tour_package.dart';
import 'package:fyp_project/models/instant_order.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tour Package
  Future<String> addPackage(String uid, String content, String packageType, int duration) async {
    String res = "Some error occurred";
    String packageId = const Uuid().v1();
    try {
      TourPackage tourPackage = TourPackage(
        packageID: packageId,
        ownerID: uid,
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
        packageID: packageId,
        ownerID: uid,
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
}
