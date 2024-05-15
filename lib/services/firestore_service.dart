import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nursery/model/baby.dart';
import 'package:nursery/model/nurse.dart';
import 'package:nursery/model/room.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/utils/formatter.dart';

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
    firestore.collection('user').doc(userId).update(baby.toJson());
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
      roomsList.add(Room.fromJson(data));
    });

    return roomsList;
  }

  Future<List<Room>?> getBookedRooms() async {
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

      // Fetching the referenced room document
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
            parentId: userSnapshot.id,
            baby: baby,
            bookingDate:
                Formatter.convertTimestampToDateTime(data['bookingDate'])),
      );
    }

    return roomsList;
  }
}
