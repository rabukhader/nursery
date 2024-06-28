import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/utils/buttons.dart';
import 'package:nursery/utils/colors.dart';
import 'package:nursery/utils/toaster.dart';
import 'package:http/http.dart' as http;

import '../../app/nursery_app.dart';

class HomePageProvider extends ChangeNotifier {
  final AuthStore authStore;
  User? userData;
  UserType userType;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool? _api;

  String? _ip;

  String? get ip => _ip;

  set setIp(value) {
    _ip = value;
    notifyListeners();
  }

  StreamSubscription? notificationEventSubscription;

  HomePageProvider(this.authStore, this.userType) {
    init();
  }

  void init() async {
    try {
      _isLoading = true;
      notifyListeners();
      userData = await authStore.getUser();
      if (userType == UserType.parents) {
        _startListening();
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future _startListening() async {
    await await getIp();
    while (_api == true) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchData();
    }
  }

  Future<void> fetchData() async {
    var url = 'http://$_ip:5000/timestamps';

    try {
      print("here");

      final response = await http.get(Uri.parse(url));
      print(response);
      var data = jsonDecode(response.body);
      if (data != null && data is List && data.isNotEmpty) {
        ErrorUtils.showNotificationMessage(
            rootNavigatorKey.currentState!.context, "Your Baby is crying",
            textColor: kPrimaryColor,
            backgroundColor: kWhiteColor.withOpacity(0.9),
            appearanceDuration: 5,
            borderRadius: 12);
      }
      print(data);
    } catch (e) {
      print(e);
    }
  }

  getIp() async {
    _api = true;
    await showDialog(
        context: rootNavigatorKey.currentState!.context,
        builder: (BuildContext context) {
          final TextEditingController ipController = TextEditingController();
          final GlobalKey<FormState> formKey = GlobalKey<FormState>();
          return AlertDialog(
            title: const Text('Enter IP Address'),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: ipController,
                decoration: const InputDecoration(
                  labelText: 'IP Address',
                  hintText: '192.168.....',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  // Simple regex to validate IP address
                  const ipPattern = r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$';
                  if (value == null || value.isEmpty) {
                    return 'Please enter an IP address';
                  }
                  if (!RegExp(ipPattern).hasMatch(value)) {
                    return 'Please enter a valid IP address';
                  }
                  return null;
                },
              ),
            ),
            actions: <Widget>[
              QSecondaryButton(
                label: "Cancel",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              QPrimaryButton(
                label: "Change",
                onPressed: () {
                  if (formKey.currentState?.validate() == true) {
                    _ip = ipController.text;
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _api = false;
    print(_api);
    super.dispose();
  }
}
