import 'package:flutter/material.dart';
import 'package:nursery/model/baby.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/services/firestore_service.dart';

class ParentDashboardProvider extends ChangeNotifier {
  final AuthStore authStore;
  final FirestoreService firestore;
  List<Baby>? babies;

  bool _isLoadingBabies = false;

  bool get isLoadingBabies => _isLoadingBabies;

  User? userData;

  ParentDashboardProvider(this.firestore, this.authStore){
    loadData();
  }

    Future loadData() async {
    try {
      _isLoadingBabies = true;
      notifyListeners();
      await loadUserData();
      await getUserBabies();
      if(babies != null){
        babies!.insert(0, Baby(id: "454545", gender: "female", fullname: "test"));
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoadingBabies = false;
      notifyListeners();
    }
  }

  Future addBaby(Baby baby) async {
    try {
      _isLoadingBabies = true;
      notifyListeners();
      await firestore.addBaby(baby: baby, userId: userData!.id);
    } catch (e) {
      print(e);
    } finally {
      _isLoadingBabies = false;
      notifyListeners();
    }
  }

  Future loadUserData() async {
    userData = await authStore.getUser();
  }

  Future getUserBabies() async {
    babies = await firestore.getBabies(userId: userData!.id);
  }
}
