import 'package:nursery/model/baby.dart';
import 'package:nursery/utils/formatter.dart';

class Room {
  Room({required this.id, this.parentId, this.baby, this.bookingDate, this.babyId, required this.roomNumber});

  final String id;
  final String roomNumber;
  final String? parentId;
  Baby? baby;
  DateTime? bookingDate;
  final String? babyId;

  bool get isEmpty => baby == null;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
      id: json['id'],
      roomNumber: json['room_number'],
      baby: json['baby'] != null ? Baby.fromJson(json['baby']) : null,
      parentId: json['parentId'],
      babyId: json['babyId'],
      bookingDate: json['bookingDate'] != null
          ? Formatter.convertTimestampToDateTime(json['bookingDate'])
          : null);

  Map<String, dynamic> toJson() => {
        'room_number' : roomNumber,
        'id': id,
        if (baby != null) 'baby': baby!.toJson(),
        'parentId': parentId,
        'babyId':babyId,
        if (bookingDate != null)
          'bookingDate':
              Formatter.convertStringToTimestamp(bookingDate.toString())
      };
}
