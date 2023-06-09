import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:place_worth_visiting_ko/main/favorite_page.dart';
import 'package:place_worth_visiting_ko/main/map_page.dart';
import 'package:place_worth_visiting_ko/main/setting_page.dart';
import 'package:sqflite/sqflite.dart';

class MainPage extends StatefulWidget {
  final Future<Database> database;

  const MainPage({
    super.key,
    required this.database,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  FirebaseDatabase? _database = FirebaseDatabase.instance;
  DatabaseReference? reference;
  FirebaseApp placeWorthVisitingKo = Firebase.app('PlaceWorthVisitingKo');
  String? id;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);

    _database = FirebaseDatabase.instanceFor(app: placeWorthVisitingKo);
    reference = _database!.ref();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '가볼 만한 곳=ko',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/logIn'),
            child: const Text(
              'Log in',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: controller,
        children: [
          MapPage(
            databaseReference: reference,
            id: id,
            db: widget.database,
          ),
          FavoritePage(
            databaseReference: reference,
            id: id,
            db: widget.database,
          ),
          SettingPage(
            databaseReference: reference,
            id: id,
          ),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: controller,
        labelColor: Theme.of(context).canvasColor,
        indicatorColor: Theme.of(context).focusColor,
        tabs: const [
          Tab(
            icon: Icon(
              Icons.location_on_outlined,
              size: 29,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.star_rate_rounded,
              size: 30,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.settings,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
