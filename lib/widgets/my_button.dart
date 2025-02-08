import 'package:flutter/material.dart';
import 'package:instagram_clone/utiles/app_colors.dart';

class MyButton extends StatelessWidget {
  final Widget title;
  final VoidCallback ontap;
  final Color backgColor;
  const MyButton({
    super.key,
    required this.title,
    required this.ontap,
    this.backgColor = blueColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ontap,
        child: Container(
          decoration: BoxDecoration(
              color: backgColor,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.grey)),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: Center(
            child: title,
          ),
        ));
  }
}
