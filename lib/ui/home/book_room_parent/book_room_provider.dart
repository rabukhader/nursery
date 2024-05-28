import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/model/baby.dart';
import 'package:nursery/model/room.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/services/firestore_service.dart';

class BookRoomprovider extends ChangeNotifier {
  final FirestoreService firestore;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Room>? rooms;

  List<Room>? bookedRooms;

  List<Baby>? babies;

  List<Baby> getavailableBabies() {
    // Extract the IDs of babies in booked rooms
    Set<String> bookedBabyIds =
        (bookedRooms ?? []).map((room) => room.baby!.id).toSet();

    // Filter out babies whose IDs are in bookedBabyIds
    List<Baby> availableBabies = (babies ?? [])
        .where((baby) => !bookedBabyIds.contains(baby.id))
        .toList();

    return availableBabies;
  }

  BookRoomprovider(this.firestore) {
    loadData();
  }

  loadData() async {
    try {
      _isLoading = true;
      notifyListeners();
      rooms = await firestore.getRooms();
      bookedRooms = await getBookedRooms();
      babies = await getUserBabies();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  getBookedRooms() async {
    User? user = await GetIt.I<AuthStore>().getUser();
    if (user == null) return [];
    return await firestore.getBookedRooms(parentId: user.id);
  }

  bookRoom(BookingRoom data ) async {}

  getUserBabies() async {
    User? user = await GetIt.I<AuthStore>().getUser();
    if (user == null) return [];
    return await firestore.getBabies(userId: user.id);
  }
}


class BookingRoom{
  final String roomId;
  final String babyId;
  final DateTime time;

  BookingRoom({required this.roomId, required this.babyId, required this.time});

}