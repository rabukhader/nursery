import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nursery/app/nursery_app.dart';
import 'package:nursery/model/user.dart';

import 'auth_store.dart';
import 'package:http/http.dart' as http;

class NotificationService extends ChangeNotifier {
  final AuthStore authStore;
  UserType userType;

  NotificationService(this.authStore, this.userType) {
    startListening();
  }

  Future startListening() async {
    User? userData = await authStore.getUser();
    if (userData != null && userType == UserType.parents) {
      await Future.delayed(const Duration(seconds: 5), () async {
        await fetchData();
      });
    }
  }

  Future<void> fetchData() async {
    const url = 'http://10.0.2.2:5000/timestamps';

    final response = await http.get(Uri.parse(url));

    // Decode the JSON response
    var data = jsonDecode(response.body);

    if (data != null && data is List && data.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 2), () {
        eventBus.fire(
            NotificationEvent("Your Baby is Crying \n Tap to Enter The Room"));
        // startListening();
        // startListening();
      });
    }
    startListening();
  }
}

class NotificationEvent {
  final dynamic data;
  NotificationEvent(this.data);
}
