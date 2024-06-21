import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ErrorUtils {

  static Future<dynamic> showMessage(BuildContext context, String message,
      {FlushbarPosition? position,
      Color? backgroundColor,
      double? borderRadius,
      Color? textColor,
      int? appearanceDuration,
      int? animationDuration}) async {
    Flushbar flushBar = Flushbar(
      flushbarPosition: position ?? FlushbarPosition.TOP,
      backgroundColor:
          backgroundColor ?? const Color.fromARGB(255, 94, 203, 117),
      borderRadius: BorderRadius.circular(borderRadius ?? 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      messageText: Row(
        children: <Widget>[
          Expanded(
            child: Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color:
                        textColor ?? const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(50, 12, 50, 12),
      duration: Duration(seconds: appearanceDuration ?? 3),
      animationDuration: Duration(milliseconds: animationDuration ?? 300),
    );

    return flushBar.show(context);
  }
}