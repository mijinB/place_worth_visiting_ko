import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final DatabaseReference? databaseReference;
  final String? id;

  const SettingPage({
    super.key,
    required this.databaseReference,
    required this.id,
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text(
              '\u{1F308}',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              ' 설정',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              const Text(
                '버튼을 누르면 즉시 로그아웃 됩니다.',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 30,
                width: 100,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  child: const Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                '계정을 영구적으로 삭제하시겠습니까?',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 30,
                width: 100,
                child: ElevatedButton(
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
                            '계정 삭제',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          content: const Text(
                            '계정을 삭제하시겠습니까?',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                widget.databaseReference!
                                    .child('user')
                                    .child(widget.id!)
                                    .remove();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/', (route) => false);
                              },
                              child: Text(
                                '예',
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
                                '아니요',
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
                    '회원탈퇴',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
