// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/user_model.dart' as model;

class AuthServices {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  // StorageServices storageServices = StorageServices();

  // get user details

  Future<model.User> getUserDetails() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot snap =
        await firestore.collection("users").doc(currentUser.uid).get();

    return model.User.fromSnapshot(snap);
  }

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        // Register user
        UserCredential credential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Encode image as Base64 string
        String base64Image = base64Encode(file);

        model.User userModel = model.User(
          username: username,
          uid: credential.user!.uid,
          photoUrl: base64Image,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );

        // Add user data to Firestore
        await firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(userModel.toJson());

        res = 'Success';
      } else {
        res = 'Please fill in all fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // sign in user

  Future<String> signInUser(
      {required String email, required String password}) async {
    String res = 'some error occured';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  void signOut() async {
    await auth.signOut();
  }
}
