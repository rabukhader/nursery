import 'package:nursery/model/baby.dart';

class User {
  User({
    required this.id,
    required this.email,
    required this.password,
    required this.userNumber,
    required this.gender,
    required this.fullname,
    this.babies
  });

  final String id;
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
      babies: json['babies']?.map((e) => Baby.fromJson(e)).toList()
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'password': password,
        'userNumber': userNumber,
        'gender': gender,
        'fullname': fullname,
        'babies': babies
      };
}

enum UserType { nursery, parents }
