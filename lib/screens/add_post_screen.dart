// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resourcess/firestore_methods.dart';
import 'package:instagram_clone/utiles/app_colors.dart';
import 'package:instagram_clone/utiles/utiles.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;
  // post on firebase the post

  postImage(String uid, String username, String profImag) async {
    setState(() {
      isLoading = true;
    });
    try {
      final res = await FirestoreMethods().uploadPost(
          descriptionController.text, _file!, uid, username, profImag);
      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Posted')));
        clearImage();
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res)));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Oops poste feild!${e.toString()}')));
    }
  }

  // after post remove the image
  void clearImage() {
    setState(() {
      _file = null;
    });
  }

// take image form gallary and camra
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16),
                child: Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16),
                child: Text('Cancel'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    User userModel = Provider.of<UserProvider>(context).getUser;

    // Decode Base64 to Uint8List for displaying the profile picture
    Uint8List? profileImage =
        userModel.photoUrl != null ? base64Decode(userModel.photoUrl) : null;

    return _file == null
        ? Center(
            child: IconButton(
              icon: Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: clearImage,
                icon: Icon(Icons.arrow_back),
              ),
              title: const Text('Post to'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: TextButton(
                    onPressed: () {
                      postImage(userModel.uid, userModel.username,
                          userModel.photoUrl);
                    },
                    child: Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  isLoading
                      ? LinearProgressIndicator()
                      : Padding(padding: EdgeInsets.only(top: 0)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundImage: profileImage != null
                            ? MemoryImage(profileImage)
                            : null,
                        child: profileImage == null
                            ? Icon(Icons.person, size: 40)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          controller: descriptionController,
                          maxLines: 8,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write a caption...',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: AspectRatio(
                          aspectRatio: 478 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
