import 'package:flutter/foundation.dart';
import 'package:nursery/model/baby.dart';
import 'package:nursery/model/room.dart';
import 'package:nursery/services/firestore_service.dart';

class BookRoomprovider extends ChangeNotifier {
  final FirestoreService firestore;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Room>? rooms;

  List<Room>? bookedRooms;

  List<Baby>? babies;

  BookRoomprovider(this.firestore) {
    loadData();
  }

  loadData() async {
    try {
      _isLoading = true;
      notifyListeners();
      rooms = await firestore.getRooms();
      bookedRooms = await firestore.getBookedRooms();
      babies = await getUserBabies();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bookRoom(roomId , babyId) async {
    
  }
  
  getUserBabies() async {
    return await firestore.getBabies(userId: userId);
  }


}
