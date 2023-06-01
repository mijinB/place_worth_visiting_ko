import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:place_worth_visiting_ko/data/content_type_data.dart';
import 'package:place_worth_visiting_ko/data/place_data.dart';
import 'package:place_worth_visiting_ko/main/place_detail_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  final DatabaseReference? databaseReference;
  final Future<Database>? db;
  final String? id;

  const MapPage({
    super.key,
    this.databaseReference,
    this.db,
    this.id,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Map<String, dynamic>> areaData = List.empty(growable: true);
  List<Map<String, dynamic>> sigunguData = List.empty(growable: true);
  List<DropdownMenuItem<Item>> sublist = List.empty(growable: true);
  List<PlaceData> placeData = List.empty(growable: true);
  ScrollController? _scrollController;

  String authKey =
      'ZsQcdTlU4hciJ7q2q6Xj2TeMu5FxCPiz4GGIOn1xFo%2BW0%2BTV6UePpAW%2BaPVJYQUi%2BRs3vrKvrBR08EwJQ6fvgA%3D%3D';

  String areaCode = "";
  String sigunguCode = "";
  Item? contentTypeId;
  int page = 1;
  int totalCount = 0;
  String contentId = "";

  void getAreaList({
    required String area,
  }) async {
    try {
      final url =
          'https://apis.data.go.kr/B551011/KorService1/areaCode1?serviceKey=$authKey&MobileOS=AND&MobileApp=PlaceWorthVisitingKo&_type=json&areaCode=$area&numOfRows=30';

      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      List<Map<String, dynamic>> resultData = List.empty(growable: true);

      if (json['response']['header']['resultCode'] == "0000") {
        json['response']['body']['items']['item'].forEach((element) {
          resultData.add(element);
        });
        if (area == "") {
          setState(() {
            areaData = resultData;
          });
        } else {
          setState(() {
            sigunguData = resultData;
          });
        }
      }
    } catch (error) {
      print('getAreaList error : $error');
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('데이터를 불러오는데 실패했어요.'),
          );
        },
      );
    }
  }

  void getAreaItemList({
    required String area,
    required String sigungu,
    required String contentTypeId,
    required int page,
  }) async {
    try {
      final url =
          'https://apis.data.go.kr/B551011/KorService1/areaBasedList1?serviceKey=$authKey&MobileOS=AND&MobileApp=PlaceWorthVisitingKo&_type=json&areaCode=$area&sigunguCode=$sigungu&contentTypeId=$contentTypeId&numOfRows=10&pageNo=$page';

      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      List<PlaceData> resultData = List.empty(growable: true);

      if (json['response']['header']['resultCode'] == "0000") {
        json['response']['body']['items']['item'].forEach((element) {
          resultData.add(PlaceData.fromJson(element));
        });
        setState(() {
          placeData.addAll(resultData);
          totalCount = json['response']['body']['totalCount'];
        });
      }
    } catch (error) {
      print('getAreaItemList error : $error');
      if (contentTypeId == '25') {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('이 지역은 여행코스 데이터가 없습니다.'),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('데이터를 불러오는데 실패했어요.'),
            );
          },
        );
      }
    }
  }

  ImageProvider getImage(String imagePath) {
    if (imagePath != '') {
      return NetworkImage(imagePath);
    } else {
      return const AssetImage('assets/images/location.png');
    }
  }

  void insertPlace(Future<Database> db, PlaceData placeInfo) async {
    print(placeInfo.toMap());
    final Database database = await db;
    await database
        .insert('place', placeInfo.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('즐겨찾기에 추가되었습니다.'),
          ),
        );
      },
    );
  }

  void _scrollToTop() {
    setState(() {
      _scrollController!.jumpTo(0);
    });
  }

  @override
  void initState() {
    super.initState();

    getAreaList(area: "");
    getAreaList(area: "1");

    sublist = ContentTypeId().contentTypeIds;

    areaCode = '1';
    sigunguCode = "1";
    contentTypeId = sublist[0].value;

    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (placeData.length < totalCount) {
        if (_scrollController!.offset >=
                _scrollController!.position.maxScrollExtent &&
            !_scrollController!.position.outOfRange) {
          page++;
          getAreaItemList(
            area: areaCode,
            sigungu: sigunguCode,
            contentTypeId: contentTypeId!.typeId,
            page: page,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.27,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).canvasColor,
                        ),
                      ),
                      onPressed: () {
                        page = 1;
                        placeData.clear();
                        getAreaItemList(
                          area: areaCode,
                          sigungu: sigunguCode,
                          contentTypeId: contentTypeId!.typeId,
                          page: page,
                        );
                        _scrollToTop();
                      },
                      child: Text(
                        '검색하기',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton(
                    dropdownColor: Theme.of(context).primaryColor,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).canvasColor,
                    ),
                    items: areaData.map((map) {
                      return DropdownMenuItem(
                        value: map['code'].toString(),
                        child: Text(map['name']),
                      );
                    }).toList(),
                    value: areaCode,
                    onChanged: (value) async {
                      getAreaList(area: value!);

                      setState(() {
                        areaCode = value;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: DropdownButton(
                      isExpanded: true,
                      dropdownColor: Theme.of(context).primaryColor,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).canvasColor,
                      ),
                      items: sigunguData.map((map) {
                        return DropdownMenuItem(
                          value: map['code'].toString(),
                          child: Text(map['name']),
                        );
                      }).toList(),
                      value: sigunguCode,
                      onChanged: (value) {
                        setState(() {
                          sigunguCode = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: DropdownButton(
                      isExpanded: true,
                      dropdownColor: Theme.of(context).primaryColor,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).canvasColor,
                      ),
                      items: sublist,
                      value: contentTypeId,
                      onChanged: (value) {
                        setState(() {
                          contentTypeId = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: placeData.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PlaceDetailPage(
                                placeData: placeData[index],
                                index: index,
                                databaseReference: widget.databaseReference,
                                id: widget.id,
                                contentId: placeData[index].contentId!,
                                contentTypeId: contentTypeId!.typeId,
                              ),
                            ),
                          );
                        },
                        onDoubleTap: () {
                          insertPlace(
                            widget.db!,
                            placeData[index],
                          );
                        },
                        child: Row(
                          children: [
                            Hero(
                              tag: 'placeinfo$index',
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image:
                                        getImage(placeData[index].imagePath!),
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).focusColor,
                                    width: 2.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 175,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    placeData[index].title!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    '주소 : ${placeData[index].address}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  placeData[index].tel! != ""
                                      ? Text(
                                          '전화번호 : ${placeData[index].tel!}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w100,
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
