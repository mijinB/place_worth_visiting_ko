import 'dart:convert';

class DetailData {
  String? contentId;
  String? expGuide;
  String? useTime;
  String? parking;

  DetailData({
    this.contentId,
    required this.expGuide,
    required this.useTime,
    required this.parking,
  });

  DetailData.fromJson(Map data)
      : contentId = jsonDecode(jsonEncode(data))['contentid'],
        expGuide = jsonDecode(jsonEncode(data))['expguide'],
        useTime = jsonDecode(jsonEncode(data))['usetime'],
        parking = jsonDecode(jsonEncode(data))['parking'];

  Map<String, dynamic> toMap() {
    return {
      'contentId': contentId,
      'expGuide': expGuide,
      'useTime': useTime,
      'parking': parking,
    };
  }
}
