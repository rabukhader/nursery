import 'package:flutter/foundation.dart';
import 'package:nursery/model/room.dart';
import 'package:nursery/services/firestore_service.dart';

class BookRoomprovider extends ChangeNotifier {
  final FirestoreService firestore;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Room>? rooms;

  List<Room>? bookedRooms;


  BookRoomprovider(this.firestore){
    loadData();
  }
  
  loadData() async {
     try {
      _isLoading = true;
      notifyListeners();
      rooms = await firestore.getRooms();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}