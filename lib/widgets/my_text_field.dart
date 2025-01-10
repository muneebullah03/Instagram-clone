import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obsecure;
  final TextInputType textInputType;

  const MyTextField(
      {super.key,
      required this.textInputType,
      required this.hintText,
      required this.controller,
      this.obsecure = false});

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: obsecure,
        decoration: InputDecoration(
            hintText: hintText,
            border: inputBorder,
            enabledBorder: inputBorder,
            filled: true,
            contentPadding: EdgeInsets.all(8)));
  }
}
