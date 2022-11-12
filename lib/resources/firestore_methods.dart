import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_project/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import 'package:fyp_project/models/tour_package.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addPackage(String uid, String content, String packageType) async {
    String res = "Some error occurred";
    String packageId = const Uuid().v1();
    try {
      TourPackage tourPackage = TourPackage(
        packageID: packageId,
        ownerID: uid,
        packageType: packageType,
        content: content,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      );
      _firestore.collection('tourPackages').doc(packageId).set(tourPackage.toJson());
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  // required this.packageID,
  // required this.ownerID,
  // required this.packageType,
  // required this.content,
  // required this.startDate,
  // required this.endDate,
}
