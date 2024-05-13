class Baby {
  Baby({
    required this.id,
    required this.gender,
    required this.fullname,
    this.image,
  });

  final String id;
  String? image;
  String? gender;
  String? fullname;

  factory Baby.fromJson(Map<String, dynamic> json) => Baby(
      id: json['id'],
      image: json['image'],
      gender: json['gender'],
      fullname: json['fullname']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'gender': gender,
        'fullname': fullname,
      };
}
