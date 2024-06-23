import 'package:flutter/foundation.dart';
import 'package:nursery/model/baby.dart';
import 'package:nursery/services/firestore_service.dart';

class MonitoringProvider extends ChangeNotifier {
  FirestoreService firestore;

  Baby? babyData;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  MonitoringProvider({required this.firestore}) {
    loadData();
  }

  loadData() async {
    try {
      _isLoading = true;
      notifyListeners();
      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
