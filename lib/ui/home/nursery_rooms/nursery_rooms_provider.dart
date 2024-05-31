import 'package:flutter/foundation.dart';
import 'package:nursery/model/room.dart';
import 'package:nursery/services/firestore_service.dart';

class NurseryRoomsProvider extends ChangeNotifier {
  final FirestoreService firestore;
  bool _isLoading = false;

  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));

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

  List<Room>? getRemainingRooms() {
    List<Room>? remainingBookedRooms = getRemainingBookedRooms();

    if (remainingBookedRooms == null) {
      return rooms; // No booked rooms, so all rooms are remaining
    }

    // Remove rooms that are also in the remainingBookedRooms list
    rooms?.removeWhere((room) => remainingBookedRooms.contains(room));

    return rooms;
  }

  List<Room>? getRemainingBookedRooms() {
    return (bookedRooms ?? [])
        .where((element) => element.bookingDate!.isAfter(yesterday))
        .toList();
  }

  addRoom() async {
    try {
      _isAddingRoom = true;
      notifyListeners();
      await firestore.addRoom(getNewRoomNumber());
      rooms = await firestore.getRooms();
    } catch (e) {
      print(e);
    } finally {
      _isAddingRoom = false;
      notifyListeners();
    }
  }

  String getNewRoomNumber() {
    int max = 0;
    for (int i = 0; i < (rooms ?? []).length; i++) {
      if (int.parse(rooms![i].roomNumber) > max) {
        max = int.parse(rooms![i].roomNumber);
      }
    }
    return (max + 1).toString();
  }
}
