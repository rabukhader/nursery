import 'package:firebase_auth/firebase_auth.dart';
import 'package:nursery/services/auth_store.dart';

class FirebaseAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final AuthStore authStore;
  FirebaseAuthService({required this.authStore});

  Future<UserCredential> login(
      {required String email, required String password}) async {
    return await auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signUp({required email, required password}) async {
    UserCredential user =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return user;
  }

  Future logout() async{
    await auth.signOut();
  }
}
