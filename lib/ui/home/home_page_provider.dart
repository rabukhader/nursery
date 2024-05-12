import 'package:flutter/material.dart';
import 'package:nursery/services/auth_store.dart';

class HomePageProvider extends ChangeNotifier {
  final AuthStore authStore;

  HomePageProvider(this.authStore) {
    init();
  }
  
  void init() {}
}