import 'package:cloud_firestore/cloud_firestore.dart';

DateTime convertToDateTime(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return timestamp.toDate(); // Firestore Timestamp → DateTime
  } else if (timestamp is int) {
    return DateTime.fromMillisecondsSinceEpoch(
      timestamp,
    ); // Unix Epoch → DateTime
  } else if (timestamp is String) {
    final timeReturned = DateTime.tryParse(timestamp);
    if (timeReturned == null) {
      throw ArgumentError(
        'ConvertToDatetime: Invalid date string format: $timestamp',
      );
    }
    return timeReturned; // ISO8601 String → DateTime
  } else {
    throw ArgumentError('Unsupported timestamp format: $timestamp');
  }
}

String numDaysToAmountOfTimeName(int day) {
  if (day == 1) {
    return "Day";
  }
  if (day == 7) {
    return "Week";
  }
  if (day == 30) {
    return "Month";
  }
  if (day % 30 == 0) {
    return "${(day / 30).toInt()} Months";
  }
  if (day % 7 == 0) {
    return "${(day / 7).toInt()} Weeks";
  }
  return "$day Days";
}
