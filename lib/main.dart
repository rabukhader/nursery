import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/firebase_auth_service.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/services/notification_service.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/app/nursery_app.dart';
import 'package:nursery/services/auth_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  _setupGetIt();

  runApp(const NurseryApp());
}

void _setupGetIt() {
  GetIt.I.registerLazySingleton<AuthStore>(() => AuthStore());
  GetIt.I.registerLazySingleton<FirestoreService>(() => FirestoreService());
  GetIt.I.registerLazySingleton<FirebaseAuthService>(
      () => FirebaseAuthService(authStore: GetIt.I<AuthStore>()));
    GetIt.I.registerLazySingleton<NotificationService>(
      () => NotificationService(GetIt.I<AuthStore>(), UserType.nursery),);
}
