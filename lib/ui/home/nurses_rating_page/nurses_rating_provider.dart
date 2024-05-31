import 'package:flutter/material.dart';
import 'package:nursery/model/nurse.dart';
import 'package:nursery/services/firestore_service.dart';

class NursesRatingProvider extends ChangeNotifier {
  final FirestoreService firestore;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Nurse>? nurses;

  NursesRatingProvider({required this.firestore}) {
    loadData();
  }

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

  getNurses() async {
    nurses = await firestore.getNurses();
  }

  addRating(NurseRating nurseRating) async {
    await firestore.addNurseRating(nurseRating);
  }
}

class NurseRating {
  final double rating;
  final String feedback;
  final String nurseId;
  final int numberOfRatingUsers;

  NurseRating(
      {required this.numberOfRatingUsers, required this.rating, required this.feedback, required this.nurseId});
}
