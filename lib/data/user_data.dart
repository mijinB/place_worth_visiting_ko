import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class UserData {
  String id;
  String pw;
  String createTime;

  UserData({
    required this.id,
    required this.pw,
    required this.createTime,
  });

  UserData.fromSnapshot(DataSnapshot snapshot)
      : id = jsonDecode(jsonEncode(snapshot.value))['id'],
        pw = jsonDecode(jsonEncode(snapshot.value))['pw'],
        createTime = jsonDecode(jsonEncode(snapshot.value))['createTime'];

  toJson() {
    return {
      'id': id,
      'pw': pw,
      'createTime': createTime,
    };
  }
}
