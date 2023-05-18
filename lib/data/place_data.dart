import 'dart:convert';

class PlaceData {
  String? contentId;
  String? mapx;
  String? mapy;
  String? title;
  String? tel;
  String? zipcode;
  String? address;
  String? imagePath;

  PlaceData({
    this.contentId,
    required this.mapx,
    required this.mapy,
    required this.title,
    required this.tel,
    required this.zipcode,
    required this.address,
    required this.imagePath,
  });

  PlaceData.fromJson(Map data)
      : contentId = jsonDecode(jsonEncode(data))['contentid'],
        mapx = jsonDecode(jsonEncode(data))['mapx'],
        mapy = jsonDecode(jsonEncode(data))['mapy'],
        title = jsonDecode(jsonEncode(data))['title'],
        tel = jsonDecode(jsonEncode(data))['tel'],
        zipcode = jsonDecode(jsonEncode(data))['zipcode'],
        address = jsonDecode(jsonEncode(data))['addr1'],
        imagePath = jsonDecode(jsonEncode(data))['firstimage'];

  Map<String, dynamic> toMap() {
    return {
      'contentId': contentId,
      'mapx': mapx,
      'mapy': mapy,
      'title': title,
      'tel': tel,
      'zipcode': zipcode,
      'address': address,
      'imagePath': imagePath,
    };
  }
}
