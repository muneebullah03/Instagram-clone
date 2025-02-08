// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/post_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  // post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImag) async {
    String res = 'Some error occured';

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
        likes: [],
      );

      firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // for like update and if already like then remove form list

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      // if the likes list contains the user uid, we need to remove it
      if (likes.contains(uid)) {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        // else we need to add uid to the likes array
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      return print(e.toString());
    }
  }

  // for post comments

  Future<void> postComments(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      String commentId = Uuid().v1();
      if (text.isNotEmpty) {
        await firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now()
        });
      } else {
        print('text is Empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // deleting post

  Future<void> deletePost(String postId) async {
    try {
      await firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  /// follow user
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snp = await firestore.collection('users').doc(uid).get();

      List following = (snp.data() as Map<String, dynamic>)['following'];
      if (following.contains(followId)) {
        await firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([uid])
        });
      } else {
        await firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
