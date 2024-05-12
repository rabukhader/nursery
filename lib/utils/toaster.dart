import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorUtils {
  /// Show red snack-bar on top of the app.
  /// with [exception] message.
  static Future<dynamic> showGeneralError(
      BuildContext context, dynamic exception,
      {Duration? duration}) async {
    String message = "Something Went Wrong Please Try Again";

    if (exception is String) {
      message = exception;
    } else if (kDebugMode) {
      message = exception.toString();
    }

    Flushbar flushBar = Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.red,
      borderRadius: BorderRadius.circular(5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      messageText: Row(
        children: <Widget>[
          GestureDetector(
            child: const Icon(Icons.close, color: Colors.white),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 8),
          Expanded(
              child:
                  Text(message, style: const TextStyle(color: Colors.white))),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(32, 12, 32, 12),
      duration: duration ?? const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 300),
    );
    return flushBar.show(context);
  }

  static Future<dynamic> showSuccessMessage(
      BuildContext context, String message) {
    Flushbar flushBar = Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: const Color.fromARGB(255, 94, 203, 117),
      borderRadius: BorderRadius.circular(5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      messageText: Row(
        children: <Widget>[
          Expanded(
            child: Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(50, 12, 50, 12),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 300),
    );

    return flushBar.show(context);
  }

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

extension ErrorUtilsContext on BuildContext {
  Future<dynamic> showGeneralError(exception, {Duration? duration}) {
    return ErrorUtils.showGeneralError(this, exception, duration: duration);
  }

  Future<dynamic> showSuccessMessage(String message) {
    return ErrorUtils.showSuccessMessage(this, message);
  }

  Future<dynamic> showMessage(String message,
      {FlushbarPosition? position,
      Color? backgroundColor,
      double? borderRadius,
      Color? textColor,
      int? appearanceDuration,
      int? animationDuration}) {
    return ErrorUtils.showMessage(this, message,
        position: position,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        textColor: textColor,
        appearanceDuration: appearanceDuration,
        animationDuration: animationDuration);
  }
}
