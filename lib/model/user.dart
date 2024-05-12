class User {
  User({
    required this.id,
    required this.email,
    required this.password,
    required this.userNumber,
    required this.gender,
    required this.fullname,
  });

  final String id;
  String email;
  String password;
  int? userNumber;
  String? gender;
  String? fullname;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        userNumber: json['userNumber'],
        gender: json['gender'],
        fullname: json['fullname']
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'password': password,
        'userNumber': userNumber,
        'gender': gender,
        'fullname': fullname,
      };
}
