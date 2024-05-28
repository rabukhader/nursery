import 'package:flutter/material.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/services/firebase_auth_service.dart';
import 'package:nursery/services/firestore_service.dart';

class ProfilePageProvider extends ChangeNotifier {
  final AuthStore authStore;
  final FirebaseAuthService authService;
  final FirestoreService firestore;

  User? userData;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isUpdating = false;

  bool get isUpdating => _isUpdating;

  ProfilePageProvider(
      {required this.authStore,
      required this.authService,
      required this.firestore}) {
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

  Future logOut() async {
    await authService.logout();
    await authStore.logout();
  }

  Future<void> updateUser(
      {String? fullname, String? gender, int? userNumber}) async {
    try {
      _isUpdating = true;
      notifyListeners();
      await authStore.updateUser(fullname, gender, userNumber);
      await firestore.updateUserData(
          fullname, gender, userNumber, userData?.id ?? "0");
    } catch (e) {
      print(e);
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
}
