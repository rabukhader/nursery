class Room {
  Room({
    required this.id,
  });

  final String id;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}
