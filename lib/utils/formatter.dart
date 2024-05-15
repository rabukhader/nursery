import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Formatter {
  static String formatDateTimeToString(DateTime dateTime) {
    // Using DateFormat class to format DateTime object with custom pattern
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  static String timestampToString(int timestamp) {
    // Convert timestamp (milliseconds since epoch) to DateTime object
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Using DateFormat class to format DateTime object as string
    DateFormat formatter = DateFormat('yy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  static String parseTimestampToString(Timestamp timestamp) {
    // Convert Timestamp to DateTime object
    DateTime dateTime = timestamp.toDate();

    // Using DateFormat class to format DateTime object as string
    DateFormat formatter = DateFormat('yy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  static DateTime convertTimestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Timestamp convertStringToTimestamp(String dateString) {
  try {
    // Define the format of your input string
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    // Parse the string into a DateTime object
    DateTime dateTime = dateFormat.parse(dateString);
    // Convert the DateTime object to a Timestamp
    Timestamp timestamp = Timestamp.fromDate(dateTime);
    return timestamp;
  } catch (e) {
    print("Error parsing date string: $e");
    return Timestamp.now(); // return current time if parsing fails
  }
}

}
