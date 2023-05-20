import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:place_worth_visiting_ko/data/detail_data.dart';
import 'package:place_worth_visiting_ko/data/place_data.dart';
import 'package:place_worth_visiting_ko/main/place_detail_page.dart';
import 'package:sqflite/sqflite.dart';

class FavoritePage extends StatefulWidget {
  final DatabaseReference? databaseReference;
  final Future<Database>? db;
  final String? id;

  const FavoritePage({
    super.key,
    required this.databaseReference,
    required this.db,
    required this.id,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Future<List<PlaceData>>? _placeList;

  ImageProvider getImage(String? imagePath) {
    if (imagePath != '') {
      return NetworkImage(imagePath!);
    } else {
      return const AssetImage('assets/images/location.png');
    }
  }

  void deletePlace(Future<Database> db, PlaceData placeInfo) async {
    final Database database = await db;
    await database.delete('place',
        where: 'title=?', whereArgs: [placeInfo.title]).then((value) {
      setState(() {
        _placeList = getTodos();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('즐겨찾기를 해제합니다.'),
        ),
      );
    });
  }

  Future<List<PlaceData>> getTodos() async {
    final Database database = await widget.db!;
    final List<Map<String, dynamic>> maps = await database.query('place');

    return List.generate(
      maps.length,
      (index) {
        return PlaceData(
          mapx: maps[index]['mapx'].toString(),
          mapy: maps[index]['mapy'].toString(),
          title: maps[index]['title'].toString(),
          tel: maps[index]['tel'].toString(),
          zipcode: maps[index]['zipcode'].toString(),
          address: maps[index]['address'].toString(),
          imagePath: maps[index]['imagePath'].toString(),
          contentTypeId: maps[index]['contentTypeId'].toString(),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _placeList = getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text(
              '\u{2B50}',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              ' 즐겨찾기',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: _placeList,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const CircularProgressIndicator();
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.active:
                return const CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: (snapshot.data!).length,
                    itemBuilder: (context, index) {
                      List<PlaceData> placeList =
                          snapshot.data as List<PlaceData>;
                      PlaceData placeInfo = placeList[index];

                      List<DetailData> detailData =
                          snapshot.data as List<DetailData>;
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PlaceDetailPage(
                                  placeData: placeInfo,
                                  index: index,
                                  databaseReference: widget.databaseReference,
                                  id: widget.id,
                                  contentId: placeInfo.contentId!,
                                  contentTypeId: placeInfo.contentTypeId!,
                                ),
                              ),
                            );
                          },
                          onDoubleTap: () {
                            deletePlace(widget.db!, placeInfo);
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
                                      image: getImage(placeInfo.imagePath),
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
                                width: 20,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      placeInfo.title!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      '주소 : ${placeInfo.address}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                    placeInfo.tel != ""
                                        ? Text(
                                            '전화번호 : ${placeInfo.tel}',
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
                  );
                } else {
                  return const Text('No data');
                }
            }
          },
        ),
      ),
    );
  }
}
