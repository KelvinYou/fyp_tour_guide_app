import 'package:cloud_firestore/cloud_firestore.dart';

class TourPackage {
  final String packageID;
  final String ownerID;
  final String packageType;
  final String content;
  final int duration;

  const TourPackage(
      {required this.packageID,
        required this.ownerID,
        required this.packageType,
        required this.content,
        required this.duration,
      });

  static TourPackage fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TourPackage(
      packageID: snapshot["packageID"],
      ownerID: snapshot["ownerID"],
      packageType: snapshot["packageType"],
      content: snapshot["content"],
      duration: snapshot["duration"],
    );
  }

  Map<String, dynamic> toJson() => {
    "packageID": packageID,
    "ownerID": ownerID,
    "packageType": packageType,
    "content": content,
    "duration": duration,
  };
}