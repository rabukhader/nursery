import 'package:flutter/foundation.dart';
import 'package:nursery/model/baby.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/book_room_parent/book_room_provider.dart';

class MonitoringProvider extends ChangeNotifier {
  BookingRoom bookedRoomData;
  FirestoreService firestore;

  Baby? babyData;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  MonitoringProvider({required this.bookedRoomData, required this.firestore}) {
    loadData();
  }

  loadData() async {
    try {
      _isLoading = true;
      notifyListeners();
      await getBabyData();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  getBabyData() async {
    babyData = await firestore.getBabyData(bookedRoomData.parentId, bookedRoomData.babyId);
  }
}
