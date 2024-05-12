import 'package:flutter/material.dart';
import 'package:nursery/utils/colors.dart';
import 'package:nursery/utils/formatter.dart';

class DatePicker extends StatelessWidget {
  final DateTime date;
  const DatePicker({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [const Text("Date"), Text(Formatter.formatDateTimeToString(date))],
        ));
  }
}