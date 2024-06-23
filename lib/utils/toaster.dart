import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nursery/ui/home/monitoring_page/monitoring_page.dart';
import 'package:nursery/utils/icons.dart';

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

  static Future<dynamic> showNotificationMessage(
      BuildContext context, String message,
      {Color? backgroundColor,
      double? borderRadius,
      Color? textColor,
      int? appearanceDuration,
      int? animationDuration}) async {
    Flushbar flushBar = Flushbar(
      onTap: (v) => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MonitoringPage()))
      },
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor:
          backgroundColor ?? const Color.fromARGB(151, 165, 178, 168),
      borderRadius: BorderRadius.circular(borderRadius ?? 5),
      messageText: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel_outlined)),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  child: Text(message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: textColor ??
                              const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w500)),
                ),
                SvgPicture.asset(
                  kAternateBabyBoy,
                  width: 50,
                  height: 50,
                )
              ],
            ),
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      duration: Duration(seconds: appearanceDuration ?? 3),
      animationDuration: Duration(milliseconds: animationDuration ?? 300),
    );

    return flushBar.show(context);
  }
}
