// ignore_for_file: use_build_context_synchronously, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resourcess/firestore_methods.dart';
import 'package:instagram_clone/utiles/app_colors.dart';
import 'package:instagram_clone/widgets/my_button.dart';

class UserAccount extends StatefulWidget {
  final String uid;
  const UserAccount({super.key, required this.uid});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  var userData = {};
  int postLenght = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  Uint8List? profileImg;
  Uint8List? postImge;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get all post length

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLenght = postSnap.docs.length;

      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      if (userData['photoUrl'] != null) {
        profileImg = base64Decode(userData['photoUrl']);
      }
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          userData['username'] ?? 'username',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                FirestoreMethods().logout();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 40,
                      backgroundImage: profileImg != null
                          ? MemoryImage(profileImg!)
                          : AssetImage('assets/profle.png'),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postLenght, 'posts'),
                              buildStatColumn(followers, 'followers'),
                              buildStatColumn(following, 'following'),
                            ],
                          ),
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 10),
                                  child: SizedBox(
                                    height: 40,
                                    child: MyButton(
                                      title: const Text('Edit Profile'),
                                      ontap: () {},
                                      backgColor: Colors.black,
                                    ),
                                  ),
                                )
                              : isFollowing
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 10),
                                      child: SizedBox(
                                        height: 40,
                                        child: MyButton(
                                          title: const Text(
                                            'Unfollow',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          ontap: () async {
                                            await FirestoreMethods().followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['uid']);
                                            setState(() {
                                              isFollowing = false;
                                              followers--;
                                            });
                                          },
                                          backgColor: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 10),
                                      child: SizedBox(
                                        height: 40,
                                        child: MyButton(
                                          title: const Text('Follow'),
                                          ontap: () async {
                                            await FirestoreMethods().followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData['uid']);

                                            setState(() {
                                              isFollowing = true;
                                              followers++;
                                            });
                                          },
                                          backgColor: blueColor,
                                        ),
                                      ),
                                    )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  userData['username'] ?? 'username',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  userData['bio'] ?? 'description',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No post yet'),
                        );
                      }
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snp = snapshot.data!.docs[index];

                            return Container(
                              child: Image(
                                image:
                                    MemoryImage(base64Decode(snp['photoUrl'])),
                                fit: BoxFit.cover,
                              ),
                            );
                          });
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
