import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:place_worth_visiting_ko/data/user_data.dart';
import 'package:place_worth_visiting_ko/widget/my_textfield.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  FirebaseDatabase? _database = FirebaseDatabase.instance;
  DatabaseReference? _reference;
  FirebaseApp placeWorthVisitingKo = Firebase.app('PlaceWorthVisitingKo');

  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;
  TextEditingController? _pwCheckTextController;

  void makeDialog(String text) {
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
    _pwCheckTextController = TextEditingController();

    _database = FirebaseDatabase.instanceFor(app: placeWorthVisitingKo);
    _reference = _database!.ref().child('user');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                const SizedBox(
                  width: 39,
                ),
                Hero(
                  tag: 1,
                  child: Image.asset(
                    'assets/images/rainbow.png',
                    width: 38,
                    height: 38,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  '가볼 만한 곳=ko',
                ),
              ],
            ),
          ),
          body: Center(
            child: Container(
              width: 330,
              height: 520,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '회원가입 \u{1F31F}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  MyTextField(
                    width: 280,
                    text: '아이디',
                    controller: _idTextController!,
                    obscureText: false,
                    hintText: '4글자 이상으로 입력해주세요.',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    width: 280,
                    text: '비밀번호',
                    controller: _pwTextController!,
                    obscureText: true,
                    hintText: '6글자 이상으로 입력해주세요.',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    width: 280,
                    text: '비밀번호 확인',
                    controller: _pwCheckTextController!,
                    obscureText: true,
                    hintText: '',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_idTextController!.value.text.length >= 4 &&
                          _pwTextController!.value.text.length >= 6) {
                        if (_pwTextController!.value.text ==
                            _pwCheckTextController!.value.text) {
                          var bytes =
                              utf8.encode(_pwTextController!.value.text);
                          var digest = sha1.convert(bytes);
                          _reference!
                              .child(_idTextController!.value.text)
                              .push()
                              .set(UserData(
                                id: _idTextController!.value.text,
                                pw: digest.toString(),
                                createTime: DateTime.now().toIso8601String(),
                              ).toJson())
                              .then((value) => Navigator.of(context).pop());
                        } else {
                          makeDialog('\'비밀번호\'와 \'비밀번호 확인\'을 동일하게 입력해주세요.');
                        }
                      } else {
                        makeDialog('아이디와 비밀번호를 제한 길이에 맞게 입력해주세요.');
                      }
                    },
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
