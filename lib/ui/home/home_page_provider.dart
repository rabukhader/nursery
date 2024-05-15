import 'package:flutter/material.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/auth_store.dart';

class HomePageProvider extends ChangeNotifier {
  final AuthStore authStore;
  User? userData;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  HomePageProvider(this.authStore) {
    init();
  }

  void init() async {
    try {
      _isLoading = true;
      notifyListeners();
      userData = await authStore.getUser();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
