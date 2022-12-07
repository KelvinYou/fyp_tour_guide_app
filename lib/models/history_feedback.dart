import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryFeedback {
  final String feedbackId;
  final String fromId;
  final String toId;
  final DateTime feedbackDate;
  final String content;
  final num rating;

  const HistoryFeedback({
    required this.feedbackId,
    required this.fromId,
    required this.toId,
    required this.feedbackDate,
    required this.content,
    required this.rating,
  });

  static HistoryFeedback fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return HistoryFeedback(
      feedbackId: snapshot["feedbackId"],
      fromId: snapshot["fromId"],
      toId: snapshot["toId"],
      feedbackDate: snapshot["feedbackDate"],
      content: snapshot["content"],
      rating: snapshot["rating"],
    );
  }

  Map<String, dynamic> toJson() => {
    'feedbackId': feedbackId,
    'fromId': fromId,
    'toId': toId,
    'feedbackDate': feedbackDate,
    'content': content,
    'rating': rating,
  };
}