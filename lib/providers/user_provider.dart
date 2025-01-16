import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/resourcess/auth_services.dart';

class UserProvider extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    try {
      // Fetch user details and notify listeners
      User user = await _authServices.getUserDetails();
      _user = user;
      notifyListeners();
    } catch (e) {
      // Handle errors (e.g., network issues)
      print('Error fetching user details: $e');
    }
  }
}
