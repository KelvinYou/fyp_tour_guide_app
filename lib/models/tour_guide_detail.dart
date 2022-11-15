import 'package:cloud_firestore/cloud_firestore.dart';

class TourGuideDetail {
  final String tourGuideID;
  final String description;
  final String language;
  final double rating;
  final String grade;

  const TourGuideDetail(
      {required this.tourGuideID,
        required this.description,
        required this.language,
        required this.rating,
        required this.grade,
      });

  static TourGuideDetail fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TourGuideDetail(
      tourGuideID: snapshot["tourGuideID"],
      description: snapshot["description"],
      language: snapshot["language"],
      rating: snapshot["rating"],
      grade: snapshot["grade"],
    );
  }

  Map<String, dynamic> toJson() => {
    "tourGuideID": tourGuideID,
    "description": description,
    "language": language,
    "rating": rating,
    "grade": grade,
  };
}