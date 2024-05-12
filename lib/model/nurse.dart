class Nurse {
  Nurse({
    required this.id,
    required this.userNumber,
    required this.gender,
    required this.fullname,
    this.image,
  });

  final String id;
  String? image;
  int? userNumber;
  String? gender;
  String? fullname;

  factory Nurse.fromJson(Map<String, dynamic> json) => Nurse(
      id: json['id'],
      image: json['image'],
      userNumber: json['userNumber'],
      gender: json['gender'],
      fullname: json['fullname']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'userNumber': userNumber,
        'gender': gender,
        'fullname': fullname,
      };
}
