import 'package:nursery/model/baby.dart';
import 'package:nursery/utils/formatter.dart';

class Room {
  Room({required this.id, this.parentId, this.baby, this.bookingDate});

  final String id;
  final String? parentId;
  Baby? baby;
  DateTime? bookingDate;

  bool get isEmpty => baby == null;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
      id: json['id'],
      baby: json['baby'] != null ? Baby.fromJson(json['baby']) : null,
      parentId: json['parentId'],
      bookingDate: json['bookingDate'] != null
          ? Formatter.convertTimestampToDateTime(json['bookingDate'])
          : null);

  Map<String, dynamic> toJson() => {
        'id': id,
        if (baby != null) 'baby': baby!.toJson(),
        'parentId': parentId,
        if (bookingDate != null)
          'bookingDate':
              Formatter.convertStringToTimestamp(bookingDate.toString())
      };
}
