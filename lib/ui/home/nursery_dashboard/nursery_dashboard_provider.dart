import 'package:flutter/material.dart';
import 'package:nursery/model/nurse.dart';
import 'package:nursery/services/firebase_service.dart';

class NurseryDashboardProvider extends ChangeNotifier {
  FirebaseService firebase;

  List<Nurse>? nurses;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  NurseryDashboardProvider({required this.firebase}) {
    init();
  }

  void init() {}
}
