import 'package:flutter/material.dart';
import 'package:uperitivo/Models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  // Add a method to update the current user if needed
  Future<void> updateCurrentUser(UserModel newUser) async {
    _currentUser = newUser;
    notifyListeners();
  }
}
