import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/utils/colors.dart';
import 'package:nursery/utils/toaster.dart';

import '../../app/nursery_app.dart';
import '../../services/notification_service.dart';

class HomePageProvider extends ChangeNotifier {
  final AuthStore authStore;
  User? userData;
  UserType userType;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  StreamSubscription? notificationEventSubscription;

  HomePageProvider(this.authStore, this.userType) {
    init();
    if (userType == UserType.parents) {
      _startListening();
    }
  }

  _startListening() {
    notificationEventSubscription =
        eventBus.on<NotificationEvent>().listen((event) {
      ErrorUtils.showNotificationMessage(
          rootNavigatorKey.currentState!.context, 
          event.data, 
          textColor: kPrimaryColor,
          backgroundColor: kWhiteColor.withOpacity(0.9),
          appearanceDuration: 5,
          borderRadius: 12
          );
    });
  }

  void init() async {
    try {
      _isLoading = true;
      notifyListeners();
      userData = await authStore.getUser();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}