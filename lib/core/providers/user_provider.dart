import 'package:flutter/material.dart';
import '../../data/models/user_data.dart';
import '../services/firebase_service.dart';

class UserProvider with ChangeNotifier {
  UserData? _userData;
  UserData? get getUser => _userData;

  Future<void> refreshUser() async {
    UserData? userData = await AuthService().getUserDetails();
  
      _userData = userData;
      notifyListeners();
    }
  

}
