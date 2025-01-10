// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/post_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImag) async {
    String res = 'Some error occured';
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    String base64Image = base64Encode(file);

    String postId = Uuid().v1();
    try {
      PostModel post = PostModel(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          photoUrl: base64Image,
          profImag: profImag,
          likes: '');

      firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
