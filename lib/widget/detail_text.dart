import 'package:flutter/material.dart';

class DetailText extends StatelessWidget {
  final String text;

  const DetailText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }
}
