import 'package:flutter/material.dart';
import 'package:nursery/model/nurse.dart';
import 'package:nursery/services/firestore_service.dart';

class NurseryDashboardProvider extends ChangeNotifier {
  FirestoreService firestore;

  List<Nurse>? nurses;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  NurseryDashboardProvider({required this.firestore}) {
    init();
  }

  void init() async {
    await getNurses();
  }

  Future getNurses() async {
    try {
      _isLoading = true;
      notifyListeners();
      nurses = [
        Nurse(fullname: "", id: "", gender: "", userNumber: 0),
        ...await firestore.getNurses()
      ];
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future addNurse(Nurse nurse) async {
    try {
      _isLoading = true;
      notifyListeners();
      firestore.addNurse(nurse);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
