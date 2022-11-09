import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  final String uid;
  final String username;
  final String fullname;
  final int phoneNumber;
  final String email;
  final int icNumber;
  final String photoUrl;

  const User(
      {required this.uid,
        required this.username,
        required this.fullname,
        required this.phoneNumber,
        required this.email,
        required this.icNumber,
        required this.photoUrl});

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
  };
}
