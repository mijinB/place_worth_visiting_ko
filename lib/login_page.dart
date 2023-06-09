import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:place_worth_visiting_ko/data/user_data.dart';
import 'package:place_worth_visiting_ko/widget/my_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  FirebaseDatabase? _database = FirebaseDatabase.instance;
  DatabaseReference? reference;
  FirebaseApp placeWorthVisitingKo = Firebase.app('PlaceWorthVisitingKo');

  double opacity = 0;
  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;

  void makeDialog(String text) {
    if (!mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        );
      },
    );
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();

    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();

    _database = FirebaseDatabase.instanceFor(app: placeWorthVisitingKo);
    reference = _database!.ref().child('user');
  }

  @override
  void dispose() {
    _idTextController!.dispose();
    _pwTextController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Container(
              width: 330,
              height: 520,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () =>
                              Navigator.of(context).pushReplacementNamed('/'),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset('assets/images/rainbow.png'),
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          '가볼 만한 곳=ko',
                          style: TextStyle(
                            color: Theme.of(context).canvasColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyTextField(
                          width: 200,
                          text: '아이디',
                          controller: _idTextController!,
                          obscureText: false,
                          hintText: '',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyTextField(
                          width: 200,
                          text: '비밀번호',
                          controller: _pwTextController!,
                          obscureText: true,
                          hintText: '',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/sign');
                              },
                              child: const Text(
                                '회원가입',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (_idTextController!.value.text.isEmpty ||
                                    _pwTextController!.value.text.isEmpty) {
                                  makeDialog('아이디와 비밀번호를 모두 입력해주세요.');
                                } else {
                                  reference!
                                      .child(_idTextController!.value.text)
                                      .onValue
                                      .listen((event) {
                                    if (event.snapshot.value == null) {
                                      makeDialog(
                                          '\'${_idTextController!.value.text}\'의 회원 정보가 없습니다.');
                                    } else {
                                      reference!
                                          .child(_idTextController!.value.text)
                                          .onChildAdded
                                          .listen((event) {
                                        UserData user = UserData.fromSnapshot(
                                            event.snapshot);
                                        var bytes = utf8.encode(
                                            _pwTextController!.value.text);
                                        var digest = sha1.convert(bytes);
                                        if (user.pw == digest.toString()) {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                            '/',
                                            arguments:
                                                _idTextController!.value.text,
                                          );
                                        } else {
                                          makeDialog('비밀번호를 정확히 입력해주세요.');
                                        }
                                      });
                                    }
                                  });
                                }
                              },
                              child: const Text(
                                '로그인',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
