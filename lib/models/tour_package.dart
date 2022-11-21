import 'package:cloud_firestore/cloud_firestore.dart';

class TourPackage {
  final String packageId;
  final String packageTitle;
  final String ownerId;
  final String packageType;
  final String content;
  final int duration;

  const TourPackage(
      {required this.packageId,
        required this.packageTitle,
        required this.ownerId,
        required this.packageType,
        required this.content,
        required this.duration,
      });

  static TourPackage fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TourPackage(
      packageId: snapshot["packageId"],
      packageTitle: snapshot["packageTitle"],
      ownerId: snapshot["ownerId"],
      packageType: snapshot["packageType"],
      content: snapshot["content"],
      duration: snapshot["duration"],
    );
  }

  Map<String, dynamic> toJson() => {
    "packageId": packageId,
    "packageTitle": packageTitle,
    "ownerId": ownerId,
    "packageType": packageType,
    "content": content,
    "duration": duration,
  };
}