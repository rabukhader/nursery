
import 'package:flutter/material.dart';
import 'package:nursery/app/nursery_app.dart';
import 'package:nursery/model/user.dart';

import 'auth_store.dart';

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
    // const url = 'https://api.example.com/data';
    try {
      // final response = await http.get(Uri.parse(url));

      // if (response.statusCode == 200) {
      //   // If the server returns a 200 OK response, parse the JSON
      //   final data = jsonDecode(response.body);
      //   print('Data: $data');
      //   eventBus.fire(NotificationEvent(data));
      // } else {
      //   // If the server did not return a 200 OK response, throw an exception
      //   print('Failed to load data. Status code: ${response.statusCode}');
      // }
      await Future.delayed(Duration(seconds: 2), () {
        eventBus.fire(NotificationEvent("Your Baby is Crying \n Tap to Enter The Room"));
        startListening();
        // startListening();
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}

class NotificationEvent {
  final dynamic data;
  NotificationEvent(this.data);
}
