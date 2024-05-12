import 'package:flutter/material.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/services/firebase_auth_service.dart';

class ProfilePageProvider extends ChangeNotifier {
  final AuthStore authStore;
  final FirebaseAuthService authService;

  User? userData;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ProfilePageProvider({required this.authStore, required this.authService}) {
    init();
  }

  String? get getGender => userData?.gender;

  String? get getEmail => userData?.email;

  int? get getPhone => userData?.userNumber;

  Future<void> init() async {
    try {
      _isLoading = true;
      notifyListeners();
      userData = await authStore.getUser();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  logOut() {}
}
