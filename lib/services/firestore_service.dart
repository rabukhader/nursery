import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nursery/model/baby.dart';
import 'package:nursery/model/nurse.dart';
import 'package:nursery/model/user.dart';

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
      print(nurseList);
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
    print(userData);
    if (userData['babies'] != null) {
      var babiesData = userData['babies'] as List<dynamic>;
      print(babiesData);
      return babiesData.map((babyJson) => Baby.fromJson(babyJson)).toList();
    } else {
      return null;
    }
  }
}
