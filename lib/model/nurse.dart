class Nurse {
  Nurse({
    required this.id,
    required this.userNumber,
    required this.gender,
    required this.fullname,
    this.image,
    this.rate,
    this.feedback,
    this.numberOfRatingUsers
  });

  final String id;
  String? image;
  int? userNumber;
  String? gender;
  String? fullname;
  final int? rate;
  final int? numberOfRatingUsers;
  final List<String>? feedback;

  factory Nurse.fromJson(Map<String, dynamic> json) => Nurse(
      id: json['id'],
      image: json['image'],
      userNumber: json['userNumber'],
      gender: json['gender'],
      rate: json['rate'],
      numberOfRatingUsers: json['number_of_rating_users'],
      feedback: json['feedback'] != null ? List<String>.from(json['feedback']) : null,
      fullname: json['fullname']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'userNumber': userNumber,
        'gender': gender,
        'fullname': fullname,
        'feedback' : feedback,
        'rate': rate,
        'number_of_rating_users': numberOfRatingUsers
      };
}
