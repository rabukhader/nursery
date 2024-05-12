import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nursery/model/user.dart' as cuser;
import 'package:nursery/services/auth_store.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginSignupProvider extends ChangeNotifier {
  final AuthStore authStore;

  LoginSignupProvider({required this.authStore});

  bool _isLoggingIn = false;

  bool get isLoggingIn => _isLoggingIn;

  Future login(String email, String password) async {
    try {
      _isLoggingIn = true;
      notifyListeners();
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await _saveInfoOnAuthStoreAfterLogin(
          user.user?.uid ?? "", email, password);
      return "pass";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        return 'Invalid Credintials';
      } else {
        return "Something went wrong, Please try again";
      }
    } catch (e) {
      return e.toString();
    } finally {
      _isLoggingIn = false;
      notifyListeners();
    }
  }

  Future signup(String email, String password, String fullname, int userNumber,
      String gender) async {
    try {
      _isLoggingIn = true;
      notifyListeners();
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await addUserOnFirebase(cuser.User(
          email: email,
          password: password,
          fullname: fullname,
          userNumber: userNumber,
          gender: gender,
          id: user.user?.uid ?? ""));

      await _saveInfoOnAuthStoreAfterLogin(
          user.user?.uid ?? "", email, password);
      return "pass";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return "Something went wrong, Please try again";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    } finally {
      _isLoggingIn = false;
      notifyListeners();
    }
  }

  addUserOnFirebase(cuser.User user) async {
    CollectionReference userCollectionRef =
        FirebaseFirestore.instance.collection('user');
    await userCollectionRef.doc(user.id).set({
      "userNumber": user.userNumber,
      "gender": user.gender,
      "fullname": user.fullname
    });
  }

  _saveInfoOnAuthStoreAfterLogin(id, email, password) async {
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('user').doc(id);
    DocumentSnapshot documentSnapshot = await userDocRef.get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    await authStore.saveUser(cuser.User(
        fullname: data['fullname'],
        id: id,
        email: email,
        password: password,
        userNumber: data['userNumber'],
        gender: data['gender']));
  }
}
