import 'dart:convert';

import 'package:nursery/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStore {
  AuthStore();

  static const String userKey = "USER";

  Future saveUser(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(userKey, jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userString = pref.getString(userKey);

    if (userString != null && userString.isNotEmpty) {
      return User.fromJson(jsonDecode(userString));
    }
    return null;
  }

  Future logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
