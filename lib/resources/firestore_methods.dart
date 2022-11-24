import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import 'package:fyp_project/models/models.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> changeProfile(String uid, Uint8List? file) async {
    String res = "Some error occurred";

    try {
      if (file != null) {
        String photoUrl = await StorageMethods().uploadImageToStorage('TourGuideProfilePics', file, false);
        _firestore.collection('tourGuides').doc(uid).update(
          {"photoUrl": photoUrl},
        );
        res = "success";
      } else {
        res = "Please select an image";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updatePersonalDetail(String uid, String username, String fullname, double icNumber, double phoneNumber) async {
    String res = "Some error occurred";

    try {
      _firestore.collection('tourGuides').doc(uid).update({
        "username": username,
        "fullname": fullname,
        "icNumber": icNumber,
        "phoneNumber": phoneNumber,
        },);
        res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateGuideDetail(String uid, String description, String language) async {
    String res = "Some error occurred";

    try {
      _firestore.collection('tourGuides').doc(uid).update({
        "description": description,
        "language": language,
      },);
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Tour Package
  Future<String> addPackage(String uid, String packageTitle, String content, String packageType, int duration) async {
    String res = "Some error occurred";
    String packageId = const Uuid().v1();
    try {
      TourPackage tourPackage = TourPackage(
        packageId: packageId,
        packageTitle: packageTitle,
        ownerId: uid,
        packageType: packageType,
        content: content,
        duration: duration,
      );
      _firestore.collection('tourPackages').doc(packageId).set(tourPackage.toJson());
      res = "success1";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updatePackage(String packageId, String uid, String packageTitle, String content, String packageType, int duration) async {
    String res = "Some error occurred";
    try {
      TourPackage tourPackage = TourPackage(
        packageId: packageId,
        packageTitle: packageTitle,
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
      _firestore.collection('tourPackages').doc(packageId).delete();
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

  String ringgitFormatter(double amount) {
    if (amount >= 0) {
      return "+RM ${amount.toStringAsFixed(2)}";
    } else {
      amount = -amount;
      return "-RM ${amount.toStringAsFixed(2)}";
    }
  }

  Future<String> reloadEWallet(String uid, double amount) async {
    String res = "Some error occurred";

    var eWalletSnap = await FirebaseFirestore.instance
        .collection('eWallet')
        .doc("ewallet_${FirebaseAuth.instance.currentUser!.uid}")
        .get();

    String eWalletId = "ewallet_$uid";

    try {
      _firestore.collection('eWallet').doc(eWalletId).update({"balance": amount + eWalletSnap.data()!["balance"]});
      res = "success";

      addTransaction(
        uid,
        ringgitFormatter(amount),
        "Receive from Wallet",
        "Reload Balance",
        "Reload Balance",
        "eWallet Balance",
        "Successful",
      );

    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Transaction
  Future<void> addTransaction(String uid, String amount, String transactionType, String receiveFrom,
      String paymentDetails, String paymentMethod, String status) async {
    // String res = "Some error occurred";
    String transactionId = const Uuid().v1();

    try {
      TransactionRecord transaction = TransactionRecord(
        transactionId: transactionId,
        transactionAmount: amount,
        ownerId: uid,
        receiveFrom: receiveFrom,
        transactionType: transactionType,
        paymentDetails: paymentDetails,
        paymentMethod: paymentMethod,
        dateTime: DateTime.now(),
        status: status,
      );
      _firestore.collection('transactions').doc(transactionId).set(transaction.toJson());
      // res = "success";
    } catch (err) {
      // res = err.toString();
    }
    // return res;
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

  Future<String> updateVerifyIC(String uid, Uint8List? frontImg,
      Uint8List? backImg, Uint8List? holdImg) async {
    String res = "Some error occurred";
    String verifyIcId = "ic_$uid";

    try {
      if (frontImg != null && backImg != null && holdImg != null) {
        String icFrontPic = await StorageMethods().uploadImageToStorage('TourGuideIcPics', frontImg, false);
        String icBackPic = await StorageMethods().uploadImageToStorage('TourGuideIcPics', frontImg, false);
        String icHoldPic = await StorageMethods().uploadImageToStorage('TourGuideIcPics', frontImg, false);

        VerifyIc verifyIc = VerifyIc(
          verifyIcId: verifyIcId,
          ownerId: uid,
          icFrontPic: icFrontPic,
          icBackPic: icBackPic,
          icHoldPic: icHoldPic
        );

        _firestore.collection('icVerifications').doc(verifyIcId).set(verifyIc.toJson());
        res = "success";
      } else {
        res = "Please select an image";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> addChatroom(String chatroomTitle, String tourGuideId,
      String touristId, String lastMessage) async {
    String res = "Some error occurred";
    String chatroomId = const Uuid().v1();
    try {
      Chatroom chatroom = Chatroom(
        chatroomId: chatroomId,
        chatroomTitle: chatroomTitle,
        tourGuideId: tourGuideId,
        touristId: touristId,
        lastMessage: lastMessage,
        lastMessageTime: DateTime.now(),
      );
      _firestore.collection('chatrooms').doc(chatroomId).set(chatroom.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> sendMessage(String chatroomId, String fromId,
      String content, String type) async {
    String res = "Some error occurred";
    String messageId = const Uuid().v1();
    try {
      Message message = Message(
        messageId: messageId,
        chatroomId: chatroomId,
        fromId: fromId,
        content: content,
        type: type,
        timestamp: DateTime.now(),
      );
      _firestore.collection('messages').doc(messageId).set(message.toJson());

      _firestore.collection('chatrooms').doc(chatroomId).update({
        "lastMessage": content, "lastMessageTime": DateTime.now()});

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
