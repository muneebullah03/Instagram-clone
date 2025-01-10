import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/resourcess/auth_services.dart';

class UserProvider extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();
  UserModel? _user;

  UserModel? get getUser => _user;

  Future<void> refreshUser() async {
    UserModel user =
        await _authServices.getUserDetails(); // Correctly assign UserModel
    _user = user;
    notifyListeners(); // Notify listeners to update UI
  }
}
