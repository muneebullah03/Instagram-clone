// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/user_acount.dart';
import 'package:instagram_clone/utiles/app_colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();

  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'search for a users',
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
        centerTitle: true,
      ),
      body: isShowUsers
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No users found'),
                  );
                }
                return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      var userDoc = snapshot.data!.docs[index];
                      var photoUrl = userDoc['photoUrl'] ?? ''; // Base64 string
                      var username = userDoc['username'] ?? 'No username';
                      ImageProvider profileImage;
                      try {
                        if (photoUrl.isNotEmpty) {
                          Uint8List decodedBytes = base64Decode(photoUrl);
                          profileImage = MemoryImage(decodedBytes);
                        } else {
                          profileImage = const AssetImage('assets/profle.png');
                        }
                      } catch (e) {
                        profileImage =
                            const AssetImage('assets/default_avatar.png');
                      }
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserAccount(
                                        uid: userDoc['uid'],
                                      )));
                        },
                        child: ListTile(
                          leading: CircleAvatar(backgroundImage: profileImage),
                          title: Text(username),
                        ),
                      );
                    });
              })
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.custom(
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    repeatPattern: QuiltedGridRepeatPattern.inverted,
                    pattern: [
                      QuiltedGridTile(2, 2),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 2),
                    ],
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var postDoc = (snapshot.data! as dynamic).docs[index];
                      var encodedImage = postDoc['photoUrl'];
                      ImageProvider postImage;

                      try {
                        if (encodedImage.isNotEmpty) {
                          // Decode Base64 string into bytes
                          Uint8List decodedBytes = base64Decode(encodedImage);
                          postImage = MemoryImage(decodedBytes);
                        } else {
                          // Fallback to a default image if the string is empty
                          postImage = const AssetImage('assets/profle.png');
                        }
                      } catch (e) {
                        // Handle decoding errors with a default image
                        postImage = const AssetImage('assets/profle.png');
                      }

                      return Image(
                        image: postImage,
                        fit: BoxFit.cover,
                      );
                    },
                    childCount: (snapshot.data! as dynamic).docs.length,
                  ),
                );
              },
            ),
    );
  }
}
