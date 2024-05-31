import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/model/baby.dart';
import 'package:nursery/model/room.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/services/firestore_service.dart';

class BookRoomProvider extends ChangeNotifier {
  final FirestoreService firestore;

  DateTime yesterday = DateTime.now().subtract(Duration(days: 1));

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Room>? rooms;

  List<Room>? bookedRooms;

  List<Baby>? babies;

  User? userData;

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

  BookRoomProvider(this.firestore) {
    getUserData();
    loadData();
  }

  loadData() async {
    try {
      _isLoading = true;
      notifyListeners();
      await getBookedRooms();
      rooms = await firestore.getRooms();
      await cleanData();
      babies = await getUserBabies();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  cleanData() async {
    List<Room> getRoomsToDeleted = getRoomsToDelete();
    if (getRoomsToDeleted.isNotEmpty) {
      await firestore.deleteBookedRoom(getRoomsToDeleted);
      await loadData();
    }
  }

  List<Room> getRoomsToDelete() {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    return (bookedRooms ?? [])
        .where((element) => !element.bookingDate!.isAfter(yesterday))
        .toList();
  }

  getBookedRooms() async {
    User? user = await GetIt.I<AuthStore>().getUser();
    if (user == null) return [];
    bookedRooms = await firestore.getBookedRooms(parentId: user.id);
  }

  bookRoom(BookingRoom data) async {
    await firestore.bookRoom(data);
  }

  getUserBabies() async {
    User? user = await GetIt.I<AuthStore>().getUser();
    if (user == null) return [];
    return await firestore.getBabies(userId: user.id);
  }

  getUserData() async {
    try {
      userData = await GetIt.I<AuthStore>().getUser();
    } catch (e) {
      print(e);
    } finally {
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

  List<Room> getFinishedBooking() {
    DateTime now = DateTime.now();
    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    DateTime startOfYesterday = startOfToday.subtract(const Duration(days: 1));
    DateTime startOfDayBeforeYesterday =
        startOfYesterday.subtract(const Duration(days: 1));

    List<Room> finishedRoomBooking = (bookedRooms ?? []).where((bookedRoom) {
      DateTime bookingDate = bookedRoom.bookingDate ?? DateTime.now();
      return bookingDate.isBefore(startOfDayBeforeYesterday);
    }).toList();

    return finishedRoomBooking;
  }
}

class BookingRoom {
  final String roomId;
  final String babyId;
  final String parentId;
  final DateTime date;

  BookingRoom(
      {required this.parentId,
      required this.roomId,
      required this.babyId,
      required this.date});

  Map<String, dynamic> toJson() => {
        'roomId': roomId,
        'babyId': babyId,
        'parentId': parentId,
        'date': date,
      };
}
