// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resourcess/firestore_methods.dart';
import 'package:instagram_clone/utiles/app_colors.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/comments_screen.dart';

class PostCart extends StatefulWidget {
  final snap;
  const PostCart({super.key, required this.snap});

  @override
  State<PostCart> createState() => _PostCartState();
}

class _PostCartState extends State<PostCart> {
  bool isAnimating = false;
  int commentleng = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      commentleng = snap.docs.length;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            // header sections
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        MemoryImage(base64Decode(widget.snap['profImag']))),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: ['Delete']
                                    .map((e) => InkWell(
                                          onTap: () async {
                                            await FirestoreMethods().deletePost(
                                                widget.snap['postId']);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            child: Text(e),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            );
                          });
                    },
                    icon: Icon(Icons.more_vert))
              ],
            ),
          ),
          // Image section
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                widget.snap['postId'].toString(),
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.memory(
                  base64Decode(
                    widget.snap['photoUrl'],
                  ),
                  fit: BoxFit.contain,
                ),
              ),
              AnimatedOpacity(
                opacity: isAnimating ? 1 : 0,
                duration: Duration(milliseconds: 200),
                child: LikeAnimation(
                  isAnimating: isAnimating,
                  duration: Duration(milliseconds: 400),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 140,
                  ),
                  onEnd: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                ),
              )
            ]),
          ),
          Row(
            children: [
              // like button
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(
                        widget.snap['postId'].toString(),
                        user.uid,
                        widget.snap['likes'],
                      );
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? Icon(
                            Icons.favorite_rounded,
                            color: Colors.red,
                          )
                        : Icon(Icons.favorite_border)),
              ),

              // commmets button

              IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                              snap: widget.snap,
                            ))),
                icon: Icon(
                  Icons.comment_outlined,
                ),
              ),

              // share button
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () {}, icon: Icon(Icons.bookmark_border)),
              ))
            ],
          ),

          //show description and number of commants

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length} likes',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(color: primaryColor),
                          children: [
                        TextSpan(
                            text: widget.snap['username'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: ' ${widget.snap['description']}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ])),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentleng comments',
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
