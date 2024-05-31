import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nursery/model/baby.dart';
import 'package:nursery/model/nurse.dart';
import 'package:nursery/model/room.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/ui/home/book_room_parent/book_room_provider.dart';
import 'package:nursery/ui/home/nurses_rating_page/nurses_rating_provider.dart';
import 'package:nursery/utils/formatter.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirestoreService();

  Future<Map<String, dynamic>> getUserData({required String id}) async {
    DocumentReference userDocRef = firestore.collection('user').doc(id);
    DocumentSnapshot documentSnapshot = await userDocRef.get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data;
  }

  Future addUser({required User user}) async {
    CollectionReference userCollectionRef = firestore.collection('user');
    await userCollectionRef.doc(user.id).set({
      "userNumber": user.userNumber,
      "gender": user.gender,
      "fullname": user.fullname
    });
  }

  Future<List<Nurse>> getNurses() async {
    List<Nurse> nurseList = [];

    QuerySnapshot querySnapshot = await firestore.collection('nurses').get();
    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      nurseList.add(Nurse.fromJson(data));
    });

    return nurseList;
  }

  Future addNurse(Nurse nurse) async {
    await firestore.collection('nurses').add(nurse.toJson());
  }

  Future deleteNurse({required String nurseId}) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('nurses')
        .where('id', isEqualTo: nurseId)
        .get();
    querySnapshot.docs.forEach((document) async {
      await document.reference.delete();
    });
  }

  Future updateNurseData({required Nurse nurse}) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('nurses')
        .where('id', isEqualTo: nurse.id)
        .get();
    querySnapshot.docs.forEach((document) async {
      await document.reference.update(nurse.toJson());
    });
  }

  Future addBaby({required Baby baby, required String userId}) async {
    DocumentReference docRef = firestore.collection('user').doc(userId);
    await docRef.update({
      'babies': FieldValue.arrayUnion([baby.toJson()])
    });
  }

  Future<List<Baby>?> getBabies({required String userId}) async {
    DocumentSnapshot userSnapshot =
        await firestore.collection('user').doc(userId).get();

    var userData = userSnapshot.data() as Map<String, dynamic>;
    if (userData['babies'] != null) {
      var babiesData = userData['babies'] as List<dynamic>;
      return babiesData.map((babyJson) => Baby.fromJson(babyJson)).toList();
    } else {
      return null;
    }
  }

  Future<List<Room>?> getRooms() async {
    List<Room> roomsList = [];

    QuerySnapshot querySnapshot = await firestore.collection('rooms').get();
    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      roomsList.add(Room.fromJson(
          {"room_number": data['room_number'], "id": document.id}));
    });

    return roomsList;
  }

  Future<List<Room>?> getBookedRooms(
      {String? parentId, bool? nurseryWise}) async {
    List<Room> roomsList = [];

    QuerySnapshot querySnapshot =
        await firestore.collection('booked_rooms').get();
    for (var document in querySnapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      // Extracting userRef and roomRef
      DocumentReference userRef = data['parentId'];
      DocumentReference roomRef = data['roomId'];

      // Fetching the referenced user document
      DocumentSnapshot userSnapshot = await userRef.get();

      if (parentId == userSnapshot.id || nurseryWise == true) {
        DocumentSnapshot roomSnapshot = await roomRef.get();
        var roomData = roomSnapshot.data() as Map<String, dynamic>;

        // Assuming getBabies() is a function that fetches babies
        List<Baby>? babies = await getBabies(userId: userSnapshot.id);
        Baby? baby = (babies != null && babies.isNotEmpty)
            ? babies.where((element) => element.id == data['babyId']).first
            : null;

        roomsList.add(
          Room(
              id: roomData['id'],
              roomNumber: roomData['room_number'],
              parentId: userSnapshot.id,
              baby: baby,
              bookingDate: Formatter.convertTimestampToDateTime(data['date'])),
        );
      }
    }

    return roomsList;
  }

  updateUserData(
      String? fullname, String? gender, int? userNumber, String id) async {
    CollectionReference users = firestore.collection('user');
    await users.doc(id).update(
        {'user_number': userNumber, 'gender': gender, 'fullname': fullname});
  }

  addRoom(String roomNumber) async {
    DocumentReference docRef = await firestore.collection('rooms').add({
      "room_number": roomNumber,
    });

    await docRef.update({
      "id": docRef.id,
    });
  }

  String generateRandomId() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  bookRoom(BookingRoom data) async {
    DocumentReference parentRef =
        firestore.collection("user").doc(data.parentId);
    DocumentReference roomRef = firestore.collection("rooms").doc(data.roomId);

    await firestore.collection("booked_rooms").add({
      "parentId": parentRef,
      "roomId": roomRef,
      "babyId": data.babyId,
      "date": Formatter.convertStringToTimestamp(data.date.toString())
    });
  }

  addNurseRating(NurseRating nurseRating) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('nurses')
        .where('id', isEqualTo: nurseRating.nurseId)
        .get();

    for (QueryDocumentSnapshot nurseDoc in querySnapshot.docs) {
      // Extract data from the nurse document
      Map<String, dynamic> nurseData = nurseDoc.data() as Map<String, dynamic>;
      // Extract previous rating and number of rating users
      int previousRating = nurseData['rate'].toInt();
      int numberOfRatingUsers = nurseRating.numberOfRatingUsers;

      // Calculate new average rating
      double newAverageRating =
          ((previousRating * numberOfRatingUsers) + nurseRating.rating) /
              (numberOfRatingUsers + 1);

      await nurseDoc.reference.update({
        'rate': newAverageRating.toInt(),
        'number_of_rating_users': numberOfRatingUsers + 1,
        'feedback': FieldValue.arrayUnion(
            [nurseRating.feedback]), // Add feedback to the list
      });
    }
  }

  deleteBookedRoom(List<Room> getRoomsToDeleted) async {
    for (Room room in getRoomsToDeleted) {
      DocumentReference roomRef = firestore.collection('rooms').doc(room.id);

      QuerySnapshot querySnapshot = await firestore
          .collection('booked_rooms')
          .where('roomId', isEqualTo: roomRef)
          .get();

      for (QueryDocumentSnapshot bookedRoomDoc in querySnapshot.docs) {
        // Extract data from the nurse document

        await bookedRoomDoc.reference.delete();
      }
    }
  }
}
