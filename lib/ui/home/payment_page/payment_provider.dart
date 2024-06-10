import 'package:flutter/material.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/auth_store.dart';

class PaymentProvider extends ChangeNotifier {
    final AuthStore authStore;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

    User? userData;

  PaymentProvider({
    required this.authStore,
  }) {
    init();
  }

  init() async {
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

  getUserPayment() async {}
}
