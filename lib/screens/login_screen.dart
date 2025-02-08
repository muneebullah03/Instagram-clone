// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resourcess/auth_services.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/utiles/app_colors.dart';
import 'package:instagram_clone/utiles/global_veriable.dart';
import 'package:instagram_clone/widgets/my_text_field.dart';

import '../responsives/mobile_screen_layout.dart';
import '../responsives/responsive_screen_layout.dart';
import '../responsives/web_screen_layout.dart';
import '../widgets/my_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    String res = await AuthServices().signInUser(
      email: emailController.text,
      password: passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (res == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResponsiveScreenLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Container(
        width: double.infinity,
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(flex: 2, child: Container()),
            // logo
            SvgPicture.asset('assets/ic_instagram.svg',
                color: primaryColor, height: 64),
            //well come
            SizedBox(height: 50),
            // user email
            MyTextField(
              controller: emailController,
              textInputType: TextInputType.emailAddress,
              hintText: 'Enter your email',
            ),
            // password
            SizedBox(height: 20),
            MyTextField(
              controller: passwordController,
              textInputType: TextInputType.text,
              hintText: 'Enter your password',
            ),
            SizedBox(height: 30),
            //button
            MyButton(
              title: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : Text('Sign In'),
              ontap: loginUser,
            ),
            Flexible(flex: 2, child: Container()),
            // signup text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an acount?"),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
