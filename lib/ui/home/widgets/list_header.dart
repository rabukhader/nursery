import 'package:flutter/material.dart';
import 'package:nursery/utils/colors.dart';

class ListHeader extends StatelessWidget {
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final String header;
  final double? padding;
  final double? margin;
  final double? borderRadius;

  const ListHeader(
      {super.key,
      this.textColor,
      this.borderColor,
      this.backgroundColor,
      required this.header,
      this.padding,
      this.margin,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(padding ?? 8.0),
        margin: EdgeInsets.all(margin ?? 8.0),
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ?? kPrimaryColor,
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? 8.0)),
            border: Border.all(
              color: borderColor ?? kPrimaryColor,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: (Text(
              header,
              style: TextStyle(color: textColor ?? Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            )))
          ],
        ));
  }
}
