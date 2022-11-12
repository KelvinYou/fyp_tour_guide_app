import 'package:cloud_firestore/cloud_firestore.dart';

class TourPackage {
  final String packageID;
  final String ownerID;
  final String packageType;
  final String content;
  final DateTime startDate;
  final DateTime endDate;

  const TourPackage(
      {required this.packageID,
        required this.ownerID,
        required this.packageType,
        required this.content,
        required this.startDate,
        required this.endDate,
      });

  static TourPackage fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TourPackage(
        packageID: snapshot["packageID"],
        ownerID: snapshot["ownerID"],
        packageType: snapshot["packageType"],
        content: snapshot["content"],
        startDate: snapshot["startDate"],
        endDate: snapshot["endDate"]
    );
  }

  Map<String, dynamic> toJson() => {
    "packageID": packageID,
    "ownerID": ownerID,
    "packageType": packageType,
    "content": content,
    "startDate": startDate,
    "endDate": endDate
  };
}