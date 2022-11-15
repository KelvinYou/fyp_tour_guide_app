import 'package:cloud_firestore/cloud_firestore.dart';

class TwoFactorAuth {
  final String twoFaId;
  final String ownerId;
  final bool isEmailVerify;
  final bool isIcVerify;
  final String icFrontPic;
  final String icBackPic;
  final String icHoldPic;

  const TwoFactorAuth(
      {required this.twoFaId,
        required this.ownerId,
        required this.isEmailVerify,
        required this.isIcVerify,
        required this.icFrontPic,
        required this.icBackPic,
        required this.icHoldPic,
      });

  static TwoFactorAuth fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TwoFactorAuth(
      twoFaId: snapshot["twoFaId"],
      ownerId: snapshot["ownerId"],
      isEmailVerify: snapshot["isEmailVerify"],
      isIcVerify: snapshot["isIcVerify"],
      icFrontPic: snapshot["icFrontPic"],
      icBackPic: snapshot["icBackPic"],
      icHoldPic: snapshot["icHoldPic"],
    );
  }

  Map<String, dynamic> toJson() => {
    "twoFaId": twoFaId,
    "ownerId": ownerId,
    "isEmailVerify": isEmailVerify,
    "isIcVerify": isIcVerify,
    "icFrontPic": icFrontPic,
    "icBackPic": icBackPic,
    "icHoldPic": icHoldPic,
  };
}