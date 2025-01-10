import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/login_screen.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoginScreen(),
      ),
    );
  }
}
