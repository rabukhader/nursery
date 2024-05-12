class Nurse {
  Nurse({
    required this.id,
    required this.email,
    required this.userNumber,
    required this.gender,
    required this.fullname,
    required this.image,
  });

  final String id;
  String email;
  String image;
  int? userNumber;
  String? gender;
  String? fullname;

  factory Nurse.fromJson(Map<String, dynamic> json) => Nurse(
      id: json['id'],
      email: json['email'],
      image: json['image'],
      userNumber: json['userNumber'],
      gender: json['gender'],
      fullname: json['fullname']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'image': image,
        'userNumber': userNumber,
        'gender': gender,
        'fullname': fullname,
      };
}
