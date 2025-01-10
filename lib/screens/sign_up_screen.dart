import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resourcess/storage_services.dart';
import 'package:instagram_clone/responsives/mobile_screen_layout.dart';
import 'package:instagram_clone/responsives/responsive_screen_layout.dart';
import 'package:instagram_clone/responsives/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utiles/app_colors.dart';
import 'package:instagram_clone/widgets/my_text_field.dart';
import 'package:instagram_clone/widgets/my_button.dart';
import '../resourcess/auth_services.dart';
import '../utiles/utiles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  AuthServices authServices = AuthServices();
  StorageServices storageServices = StorageServices();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  bool isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    bioController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void sigUpUsers() async {
    setState(() {
      isLoading = true;
    });
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        bioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    Uint8List compressedImage =
        storageServices.compressImage(_image!); // Compress image before storing

    String res = await authServices.signUpUser(
      email: emailController.text,
      password: passwordController.text,
      username: nameController.text,
      bio: bioController.text,
      file: compressedImage,
    );
    setState(() {
      isLoading = false;
    });

    if (res != 'Success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res)),
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResponsiveScreenLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout())));
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(res)),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                // logo
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 64,
                ),
                SizedBox(height: 20),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: AssetImage('assets/profle.png'),
                          ),
                    Positioned(
                      bottom: -5,
                      left: 88,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // username
                MyTextField(
                  controller: nameController,
                  textInputType: TextInputType.text,
                  hintText: 'Enter your username',
                ),
                SizedBox(height: 20),
                // email
                MyTextField(
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Enter your email',
                ),
                SizedBox(height: 20),
                // password
                MyTextField(
                  controller: passwordController,
                  textInputType: TextInputType.text,
                  hintText: 'Enter your password',
                  obsecure: true,
                ),
                SizedBox(height: 20),
                // bio
                MyTextField(
                  controller: bioController,
                  textInputType: TextInputType.text,
                  hintText: 'Enter your bio',
                ),
                SizedBox(height: 30),
                // SignUp button
                MyButton(
                  title: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                      : Text('Sign Up'),
                  ontap: sigUpUsers,
                ),
                SizedBox(height: 40),
                // already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                        child: Text(
                          'Sign in',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
