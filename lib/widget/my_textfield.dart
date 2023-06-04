import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final double width;
  final String text;
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;

  const MyTextField({
    super.key,
    required this.width,
    required this.text,
    required this.controller,
    required this.obscureText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        style: const TextStyle(
          color: Colors.white,
        ),
        controller: controller,
        obscureText: obscureText,
        maxLines: 1,
        cursorColor: Theme.of(context).focusColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 15,
            color: Colors.white54,
            fontWeight: FontWeight.w100,
          ),
          labelText: text,
          labelStyle: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w100,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).focusColor,
            ),
          ),
        ),
      ),
    );
  }
}
