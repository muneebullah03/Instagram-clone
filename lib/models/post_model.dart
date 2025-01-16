// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String photoUrl;
  final String profImag;
  final likes;

  PostModel(
      {required this.description,
      required this.uid,
      required this.username,
      required this.postId,
      required this.datePublished,
      required this.photoUrl,
      required this.profImag,
      required this.likes});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "postId": postId,
        "datePublished": datePublished,
        "profImag": profImag,
        "likes": likes,
        "photoUrl": photoUrl,
      };

  static PostModel fromJson(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      photoUrl: snapshot['photoUrl'],
      profImag: snapshot['profImag'],
      likes: snapshot['likes'],
    );
  }
}
