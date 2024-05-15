import 'package:flutter/foundation.dart';
import 'package:nursery/model/room.dart';
import 'package:nursery/services/firestore_service.dart';

class NurseryRoomsProvider extends ChangeNotifier {
  final FirestoreService firestore;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Room>? bookedRooms;

  NurseryRoomsProvider(this.firestore) {
    loadData();
  }

  loadData() async {
    try {
      _isLoading = true;
      notifyListeners();
      bookedRooms = await firestore.getBookedRooms(nurseryWise: true);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  bookRoom() async {

  }

}