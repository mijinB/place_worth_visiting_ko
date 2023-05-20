// import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';

// class DisableInfo {
//   String? key;
//   int? physicalDisable;
//   int? visualDisable;
//   String? id;
//   String? createTime;

//   DisableInfo({
//     required this.physicalDisable,
//     required this.visualDisable,
//     required this.id,
//     required this.createTime,
//   });

//   DisableInfo.fromSnapshot(DataSnapshot snapshot)
//       : key = snapshot.key,
//         physicalDisable =
//             jsonDecode(jsonEncode(snapshot.value))['physicalDisable'],
//         visualDisable = jsonDecode(jsonEncode(snapshot.value))['visualDisable'],
//         id = jsonDecode(jsonEncode(snapshot.value))['id'],
//         createTime = jsonDecode(jsonEncode(snapshot.value))['createTime'];

//   toJson() {
//     return {
//       'physicalDisable': physicalDisable,
//       'visualDisable': visualDisable,
//       'id': id,
//       'createTime': createTime,
//     };
//   }
// }
