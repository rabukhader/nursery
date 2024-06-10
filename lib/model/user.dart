import 'package:nursery/model/baby.dart';

class User {
  User({
    required this.id,
    required this.email,
    required this.password,
    required this.userNumber,
    required this.gender,
    required this.fullname,
    required this.hasPayment,
    this.babies
  });

  final String id;
  final bool hasPayment;
  String email;
  String password;
  int? userNumber;
  String? gender;
  String? fullname;
  List<Baby>? babies;

  bool get isNursery => email.contains("nursery");

  UserType get type {
    if (isNursery) {
      return UserType.nursery;
    } else {
      return UserType.parents;
    }
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      userNumber: json['userNumber'],
      gender: json['gender'],
      fullname: json['fullname'],
      hasPayment: json['hasPayment'] ??false,
      babies: json['babies']?.map((e) => Baby.fromJson(e)).toList()
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'password': password,
        'userNumber': userNumber,
        'gender': gender,
        'fullname': fullname,
        'babies': babies,
        'hasPayment': hasPayment
      };
}

enum UserType { nursery, parents }
