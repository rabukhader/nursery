import 'package:flutter/material.dart';
import 'package:nursery/model/nurse.dart';
import 'package:nursery/services/firestore_service.dart';

class NurseryDashboardProvider extends ChangeNotifier {
  FirestoreService firestore;

  List<Nurse>? nurses;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  NurseryDashboardProvider({required this.firestore}) {
    loadData();
  }

  bool _isSaving = false;

  bool get isSaving => _isSaving;

  loadData() async {
    try {
      _isLoading = true;
      notifyListeners();
      await getNurses();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future getNurses() async {
    nurses = [
      Nurse(fullname: "", id: "", gender: "", userNumber: 0),
      ...await firestore.getNurses()
    ];
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

  Future deleteNurse(String nurseId) async {
    await firestore.deleteNurse(nurseId: nurseId);
  }

  Future updateNurseData(Nurse nurse) async {
    try {
      _isLoading = true;
      notifyListeners();
      firestore.updateNurseData(nurse: nurse);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
