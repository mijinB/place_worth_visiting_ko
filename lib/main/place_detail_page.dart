import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:place_worth_visiting_ko/data/place_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_worth_visiting_ko/data/reviews_data.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

class PlaceDetailPage extends StatefulWidget {
  final PlaceData? placeData;
  final int? index;
  final DatabaseReference? databaseReference;
  final String? id;
  final String contentId;
  final String contentTypeId;

  const PlaceDetailPage({
    super.key,
    required this.placeData,
    required this.index,
    required this.databaseReference,
    required this.id,
    required this.contentId,
    required this.contentTypeId,
  });

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CameraPosition? _googleMapCamera;
  TextEditingController? _reviewTextController;
  Marker? marker;
  List<ReviewsData> reviews = List.empty(growable: true);
  final bool _disableWidget = false;
  // DisableInfo? _disableInfo;
  double physicalDisable = 0;
  double visualDisable = 0;

  Map<String, dynamic>? detailData = {};

  String authKey =
      'ZsQcdTlU4hciJ7q2q6Xj2TeMu5FxCPiz4GGIOn1xFo%2BW0%2BTV6UePpAW%2BaPVJYQUi%2BRs3vrKvrBR08EwJQ6fvgA%3D%3D';

  void getAreaDetailInfo({
    required String contentTypeId,
  }) async {
    try {
      print('contenId : ${widget.contentId}');
      print('contentTypeId : $contentTypeId');

      final url =
          'https://apis.data.go.kr/B551011/KorService1/detailIntro1?serviceKey=$authKey&MobileOS=AND&MobileApp=PlaceWorthVisitingKo&_type=json&contentId=${widget.contentId}&contentTypeId=$contentTypeId';

      final response = await http.get(Uri.parse(url));
      print('response : $response');
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      if (json['response']['header']['resultCode'] == "0000") {
        setState(() {
          detailData = json['response']['body']['items']['item'][0];
        });
      }
    } catch (error) {
      print(error);
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

  String? getGuideInfo() {
    switch (widget.contentTypeId) {
      case '12':
        return detailData?['expguide'] != ''
            ? '\u{1F4AC} 정보 : ${detailData?['expguide']}'
            : '\u{1F4AC} 정보 데이터가 없어요.';
      case '14':
        return detailData?['usefee'] != ''
            ? '\u{1F4AC} 요금정보 : ${detailData?['usefee']}'
            : '\u{1F4AC} 정보 데이터가 없어요.';
      case '15':
        return detailData?['eventplace'] != '' ||
                detailData?['usetimefestival'] != ''
            ? '\u{1F4AC} 장소/요금정보 : ${detailData?['eventplace']} / ${detailData?['usetimefestival']}'
            : '\u{1F4AC} 정보 데이터가 없어요.';
      case '25':
        return '';
      case '28':
        return detailData?['reservation'] != ''
            ? '\u{1F4AC} 예약정보 : ${detailData?['reservation']}'
            : '\u{1F4AC} 정보 데이터가 없어요.';
      case '32':
        return detailData?['reservationurl'] != ''
            ? '\u{1F4AC} 예약정보 : ${detailData?['reservationurl']}'
            : '\u{1F4AC} 정보 데이터가 없어요.';
      case '38':
        return detailData?['shopguide'] != '' || detailData?['saleitem'] != ''
            ? '\u{1F4AC} 정보/판매종류 : ${detailData?['shopguide']} / ${detailData?['saleitem']}'
            : '\u{1F4AC} 정보 데이터가 없어요.';
      case '39':
        return detailData?['firstmenu'] != '' || detailData?['treatmenu'] != ''
            ? '\u{1F4AC} 음식종류 : ${detailData?['firstmenu']}, ${detailData?['treatmenu']}'
            : '\u{1F4AC} 정보 데이터가 없어요.';
      default:
        return '\u{1F4AC} 정보 데이터가 없어요.';
    }
  }

  String? getTimeInfo() {
    switch (widget.contentTypeId) {
      case '12':
        return detailData?['usetime'] != ''
            ? '\u{1F552} 업무시간 : ${detailData?['usetime']}'
            : '\u{1F552} 업무시간 데이터가 없어요.';
      case '14':
        return detailData?['usetimeculture'] != ''
            ? '\u{1F552} 업무시간 : ${detailData?['usetimeculture']}'
            : '\u{1F552} 업무시간 데이터가 없어요.';
      case '15':
        return detailData?['playtime'] != ''
            ? '\u{1F552} 업무시간 : ${detailData?['playtime']}'
            : '\u{1F552} 업무시간 데이터가 없어요.';
      case '25':
        return '';
      case '28':
        return detailData?['usetimeleports'] != ''
            ? '\u{1F552} 업무시간 : ${detailData?['usetimeleports']}'
            : '\u{1F552} 업무시간 데이터가 없어요.';
      case '32':
        return detailData?['checkintime'] != '' ||
                detailData?['checkouttime'] != ''
            ? '\u{1F552} 체크인/체크아웃 시간 : ${detailData?['checkintime']} / ${detailData?['checkouttime']}'
            : '\u{1F552} 체크인/체크아웃 시간 데이터가 없어요.';
      case '38':
        return detailData?['opentime'] != ''
            ? '\u{1F552} 업무시간 : ${detailData?['opentime']}'
            : '\u{1F552} 업무시간 데이터가 없어요.';
      case '39':
        return detailData?['opentimefood'] != ''
            ? '\u{1F552} 업무시간 : ${detailData?['opentimefood']}'
            : '\u{1F552} 업무시간 데이터가 없어요.';
      default:
        return '\u{1F552} 업무시간 데이터가 없어요.';
    }
  }

  String? getRestDateInfo() {
    switch (widget.contentTypeId) {
      case '12':
        return detailData?['restdate'] != ''
            ? '\u{1F4C6} 휴무일 : ${detailData?['restdate']}'
            : '\u{1F4C6} 휴무일 데이터가 없어요.';
      case '14':
        return detailData?['restdateculture'] != ''
            ? '\u{1F4C6} 휴무일 : ${detailData?['restdateculture']}'
            : '\u{1F4C6} 휴무일 데이터가 없어요.';
      case '15':
        return detailData?['eventstartdate'] != '' ||
                detailData?['eventenddate'] != ''
            ? '\u{1F4C6} 시작/종료날짜 : ${detailData?['eventstartdate']} / ${detailData?['eventenddate']}'
            : '\u{1F4C6} 시작/종료날짜 데이터가 없어요.';
      case '25':
        return '';
      case '28':
        return detailData?['restdateleports'] != ''
            ? '\u{1F4C6} 휴무일 : ${detailData?['restdateleports']}'
            : '\u{1F4C6} 휴무일 데이터가 없어요.';
      case '32':
        return detailData?['checkintime'] != ''
            ? '\u{1F373} 요리가능 여부 : ${detailData?['chkcooking']}'
            : '\u{1F373} 요리가능 여부 데이터가 없어요.';
      case '38':
        return detailData?['restdateshopping'] != ''
            ? '\u{1F4C6} 휴무일 : ${detailData?['restdateshopping']}'
            : '\u{1F4C6} 휴무일 데이터가 없어요.';
      case '39':
        return detailData?['restdatefood'] != ''
            ? '\u{1F4C6} 휴무일 : ${detailData?['restdatefood']}'
            : '\u{1F4C6} 휴무일 데이터가 없어요.';
      default:
        return '\u{1F4C6} 휴무일 데이터가 없어요.';
    }
  }

  String? getParkingInfo() {
    switch (widget.contentTypeId) {
      case '12':
        return detailData?['parking'] != ''
            ? '\u{1F17F}  주차 : ${detailData?['parking']}'
            : '\u{1F17F}  주차 데이터가 없어요.';
      case '14':
        return detailData?['parkingculture'] != ''
            ? '\u{1F17F}  주차/요금 : ${detailData?['parkingculture']} / ${detailData?['parkingfee']}'
            : '\u{1F17F}  주차 데이터가 없어요.';
      case '15':
        return detailData?['sponsor1'] != ''
            ? '\u{1F3E2} 주최기관 : ${detailData?['sponsor1']}'
            : '\u{1F3E2} 주최기관 데이터가 없어요.';
      case '25':
        return '';
      case '28':
        return detailData?['parkingleports'] != ''
            ? '\u{1F17F}  주차/요금 : ${detailData?['parkingleports']} / ${detailData?['parkingfeeleports']}'
            : '\u{1F17F}  주차 데이터가 없어요.';
      case '32':
        return detailData?['parkinglodging'] != ''
            ? '\u{1F17F}  주차 : ${detailData?['parkinglodging']}'
            : '\u{1F17F}  주차 데이터가 없어요.';
      case '38':
        return detailData?['parkingshopping'] != ''
            ? '\u{1F17F}  주차 : ${detailData?['parkingshopping']}'
            : '\u{1F17F}  주차 데이터가 없어요.';
      case '39':
        return detailData?['packing'] != ''
            ? '\u{1F17F}  주차 : ${detailData?['packing']}'
            : '\u{1F17F}  주차 데이터가 없어요.';
      default:
        return '\u{1F17F}  주차 데이터가 없어요.';
    }
  }

  // getDisableInfo() {
  //   widget.databaseReference!
  //       .child('place')
  //       .child(widget.placeData!.contentId.toString())
  //       .onValue
  //       .listen((event) {
  //     if (event.snapshot.value != null) {
  //       _disableInfo = DisableInfo.fromSnapshot(event.snapshot);

  //       if (_disableInfo == null) {
  //         setState(() {
  //           _disableWidget = false;
  //         });
  //       } else {
  //         setState(() {
  //           _disableWidget = true;
  //         });
  //       }
  //     } else {
  //       print('event.snapshot.value = null');
  //     }
  //   });
  // }

  ImageProvider getImage(String? imagePath) {
    if (imagePath != '') {
      return NetworkImage(imagePath!);
    } else {
      return const AssetImage('assets/images/location.png');
    }
  }

  // Widget setDisableWidget() {
  //   return Center(
  //     child: Column(
  //       children: [
  //         const SizedBox(
  //           height: 25,
  //         ),
  //         const Text(
  //           '(점수를 선택하고 \'데이터 저장하기\'를 눌러주세요.)',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 13,
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 10,
  //         ),
  //         Text(
  //           '지체 장애인 이용 점수 : ${physicalDisable.floor()}',
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontSize: 18,
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(20),
  //           child: Slider(
  //             value: physicalDisable,
  //             min: 0,
  //             max: 10,
  //             activeColor: Theme.of(context).focusColor,
  //             inactiveColor: Colors.white12,
  //             onChanged: (value) {
  //               setState(() {
  //                 physicalDisable = value;
  //               });
  //             },
  //           ),
  //         ),
  //         Text(
  //           '시작 장애인 이용 점수 : ${visualDisable.floor()}',
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontSize: 18,
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(20),
  //           child: Slider(
  //             value: visualDisable,
  //             min: 0,
  //             max: 10,
  //             activeColor: Theme.of(context).focusColor,
  //             inactiveColor: Colors.white12,
  //             onChanged: (value) {
  //               setState(() {
  //                 visualDisable = value;
  //               });
  //             },
  //           ),
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             SizedBox(
  //               height: 30,
  //               width: 110,
  //               child: ElevatedButton(
  //                 style: ButtonStyle(
  //                   backgroundColor: MaterialStateProperty.all(
  //                     Colors.white,
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   DisableInfo disableInfo = DisableInfo(
  //                     physicalDisable: physicalDisable.floor(),
  //                     visualDisable: visualDisable.floor(),
  //                     id: widget.id,
  //                     createTime: DateTime.now().toIso8601String(),
  //                   );
  //                   widget.databaseReference!
  //                       .child('place')
  //                       .child(widget.placeData!.contentId.toString())
  //                       .set(disableInfo.toJson())
  //                       .then((value) {
  //                     setState(() {
  //                       _disableWidget = true;
  //                     });
  //                   });
  //                 },
  //                 child: const Text(
  //                   '데이터 저장하기',
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 25,
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  getGoogleMap() {
    return SizedBox(
      height: 400,
      width: MediaQuery.of(context).size.width - 50,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        child: GoogleMap(
          initialCameraPosition: _googleMapCamera!,
          mapType: MapType.normal,
          onMapCreated: (controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(markers.values),
        ),
      ),
    );
  }

  // showDisableWidget() {
  //   return Center(
  //     child: Column(
  //       children: [
  //         const SizedBox(
  //           height: 25,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Image.asset(
  //               'assets/images/physical_disable.png',
  //               width: 37,
  //             ),
  //             const SizedBox(
  //               width: 10,
  //             ),
  //             Text(
  //               '지체 장애 이용 점수 : ${_disableInfo!.physicalDisable}',
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 18,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Image.asset(
  //               'assets/images/visual_disable.png',
  //               width: 37,
  //             ),
  //             const SizedBox(
  //               width: 10,
  //             ),
  //             Text(
  //               '시각 장애 이용 점수 : ${_disableInfo!.visualDisable}',
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 18,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             Text(
  //               '작성자 : ${_disableInfo!.id}',
  //               style: const TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w100,
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 37,
  //             ),
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 10,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             SizedBox(
  //               height: 30,
  //               width: 110,
  //               child: ElevatedButton(
  //                 style: ButtonStyle(
  //                   backgroundColor: MaterialStateProperty.all(
  //                     Colors.white,
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   setState(() {
  //                     _disableWidget = false;
  //                   });
  //                 },
  //                 child: const Text(
  //                   '점수 수정하기',
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 25,
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    widget.databaseReference!
        .child('place')
        .child(widget.placeData!.contentId.toString())
        .child('review')
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          reviews.add(ReviewsData.fromSnapshot(event.snapshot));
        });
      }
    });

    _reviewTextController = TextEditingController();

    _googleMapCamera = CameraPosition(
      target: LatLng(
        double.parse(widget.placeData!.mapy.toString()),
        double.parse(widget.placeData!.mapx.toString()),
      ),
      zoom: 16,
    );

    MarkerId markerId = MarkerId(widget.placeData.hashCode.toString());
    marker = Marker(
      markerId: markerId,
      position: LatLng(
        double.parse(widget.placeData!.mapy.toString()),
        double.parse(widget.placeData!.mapx.toString()),
      ),
      flat: true,
    );
    markers[markerId] = marker!;

    // getDisableInfo();

    getAreaDetailInfo(contentTypeId: widget.contentTypeId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Theme.of(context).focusColor,
              expandedHeight: 50,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Text(
                    '${widget.placeData!.title} \u{1F4AD}',
                    style: TextStyle(
                      color: Theme.of(context).canvasColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Hero(
                          tag: 'placeinfo${widget.index}',
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).focusColor,
                                width: 3,
                              ),
                              image: DecorationImage(
                                image: getImage(widget.placeData!.imagePath),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 25,
                          ),
                          child: Text(
                            widget.placeData!.address!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        getGoogleMap(),
                        // _disableWidget == false
                        //     ? setDisableWidget()
                        //     : showDisableWidget(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 25,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getGuideInfo()!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                getTimeInfo()!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                getRestDateInfo()!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                getParkingInfo()!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _HeaderDelegate(
                minHeight: 50,
                maxHeight: 60,
                child: Container(
                  color: Theme.of(context).canvasColor,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '후기 \u{1F48C}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 21,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.all(5),
              sliver: SliverToBoxAdapter(
                child: Text(
                  '(X 자신의 후기를 두 번 터치하면 삭제됩니다.)',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: reviews.length,
                (context, index) {
                  return Card(
                    child: InkWell(
                      onDoubleTap: () {
                        if (reviews[index].id == widget.id) {
                          widget.databaseReference!
                              .child('place')
                              .child(widget.placeData!.contentId.toString())
                              .child('review')
                              .child(widget.id!)
                              .remove();
                          setState(() {
                            reviews.removeAt(index);
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 10,
                        ),
                        child: Text(
                          '\u{1F449}   ${reviews[index].id} : ${reviews[index].review}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.white,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              '후기 작성',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            content: TextField(
                              controller: _reviewTextController,
                              cursorColor: Theme.of(context).focusColor,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).focusColor,
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  ReviewsData reviewsData = ReviewsData(
                                    id: widget.id!,
                                    review: _reviewTextController!.value.text,
                                    createTime:
                                        DateTime.now().toIso8601String(),
                                  );
                                  widget.databaseReference!
                                      .child('place')
                                      .child(widget.placeData!.contentId
                                          .toString())
                                      .child('review')
                                      .child(widget.id!)
                                      .set(reviewsData.toJson())
                                      .then((value) =>
                                          Navigator.of(context).pop());
                                },
                                child: Text(
                                  '저장하기',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  '종료하기',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      '후기 작성',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final double? minHeight;
  final double? maxHeight;
  final Widget? child;

  _HeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  double get minExtent => minHeight!;

  @override
  double get maxExtent => math.max(maxHeight!, minHeight!);

  @override
  bool shouldRebuild(_HeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
