import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/login_screen.dart';

import '../resourcess/auth_services.dart';

class UserAcount extends StatefulWidget {
  const UserAcount({super.key});

  @override
  State<UserAcount> createState() => _UserAcountState();
}

class _UserAcountState extends State<UserAcount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
                onTap: () {
                  AuthServices().signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Icon(Icons.logout_outlined)),
          ),
        ],
      ),
    );
  }
}
