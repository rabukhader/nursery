import 'package:flutter/foundation.dart';
import 'package:nursery/model/room.dart';
import 'package:nursery/services/firestore_service.dart';

class NurseryRoomsProvider extends ChangeNotifier {
  final FirestoreService firestore;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isAddingRoom = false;

  bool get isAddingRoom => _isAddingRoom;

  List<Room>? bookedRooms;

  List<Room>? rooms;

  NurseryRoomsProvider(this.firestore) {
    loadData();
  }

  loadData() async {
    try {
      _isLoading = true;
      notifyListeners();
      rooms = await firestore.getRooms();
      bookedRooms = await firestore.getBookedRooms(nurseryWise: true);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  addRoom() async {
    try {
      _isAddingRoom = true;
      notifyListeners();
      await firestore.addRoom((rooms ?? []).last.roomNumber);
      rooms = await firestore.getRooms();
    } catch (e) {
      print(e);
    } finally {
      _isAddingRoom = false;
      notifyListeners();
    }
  }
}
