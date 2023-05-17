import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class ReviewsData {
  String id;
  String review;
  String createTime;

  ReviewsData({
    required this.id,
    required this.review,
    required this.createTime,
  });

  ReviewsData.fromSnapshot(DataSnapshot snapshot)
      : id = jsonDecode(jsonEncode(snapshot.value))['id'],
        review = jsonDecode(jsonEncode(snapshot.value))['review'],
        createTime = jsonDecode(jsonEncode(snapshot.value))['createTime'];

  toJson() {
    return {
      'id': id,
      'review': review,
      'createTime': createTime,
    };
  }
}
