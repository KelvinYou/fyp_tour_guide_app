import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  final String uid;
  final String username;
  final String fullname;
  final int phoneNumber;
  final String email;
  final int icNumber;
  final String photoUrl;
  final String description;
  final String language;
  final double rating;
  final String grade;

  const User(
      {required this.uid,
        required this.username,
        required this.fullname,
        required this.phoneNumber,
        required this.email,
        required this.icNumber,
        required this.photoUrl,
        required this.description,
        required this.language,
        required this.rating,
        required this.grade,});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot["uid"],
      username: snapshot["username"],
      fullname: snapshot["fullname"],
      phoneNumber: snapshot["phoneNumber"],
      email: snapshot["email"],
      icNumber: snapshot["icNumber"],
      photoUrl: snapshot["photoUrl"],
      description: snapshot["description"],
      language: snapshot["language"],
      rating: snapshot["rating"],
      grade: snapshot["grade"],
    );
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "fullname": fullname,
    "phoneNumber": phoneNumber,
    "email": email,
    "icNumber": icNumber,
    "photoUrl": photoUrl,
    "description": description,
    "language": language,
    "rating": rating,
    "grade": grade,
  };
}
