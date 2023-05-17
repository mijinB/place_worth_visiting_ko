import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path/path.dart';
import 'package:place_worth_visiting_ko/firebase_options.dart';
import 'package:place_worth_visiting_ko/login_page.dart';
import 'package:place_worth_visiting_ko/sign_page.dart';
import 'package:place_worth_visiting_ko/main_page.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    name: 'PlaceWorthVisitingKo',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 임시 추가
  //HttpOverrides.global = MyhttpOverrides();

  runApp(const PlaceWorthVisitingKo());
}

// 임시 추가
// class MyhttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
// END 임시 추가

class PlaceWorthVisitingKo extends StatelessWidget {
  Future<Database> initDatabase() async {
    return openDatabase(
      join(
        await getDatabasesPath(),
        'place_datase.db',
      ),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE place(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, tel TEXT, zipcode TEXT, address TEXT, mapx Number, mapy Number, imagePath TEXT)",
        );
      },
    );
  }

  const PlaceWorthVisitingKo({super.key});

  @override
  Widget build(BuildContext context) {
    Future<Database> database = initDatabase();

    return MaterialApp(
      title: 'places',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff80AAFF),
        fontFamily: 'IBMPlexSansKR',
        primaryColor: const Color(0xff80AAFF),
        focusColor: const Color(0xffFF6D7A),
        canvasColor: const Color(0xffFFE773),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xff80AAFF),
          foregroundColor: Color(0xffFFE773),
          titleTextStyle: TextStyle(
            fontFamily: 'IBMPlexSansKR',
            color: Color(0xffFFE773),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/sign': (context) => const SignPage(),
        '/main': (context) => MainPage(
              database: database,
            ),
      },
    );
  }
}
