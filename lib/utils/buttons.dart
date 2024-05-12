import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nursery/utils/colors.dart';
import 'package:nursery/utils/fonts.dart';

class QPrimaryButton extends StatelessWidget {
  const QPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = kButtonColor,
    this.textColor = Colors.white,
    this.minSize = 50,
    this.fontSize = 17,
    this.fontWeight,
    this.isLoading = false,
    this.loaderColor,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  }) : icon = null;

  const QPrimaryButton.icon({
    super.key,
    required this.label,
    this.onPressed,
    this.color = kButtonColor,
    this.textColor = Colors.white,
    this.loaderColor,
    this.minSize = 50,
    this.fontSize = 17,
    this.fontWeight,
    this.isLoading = false,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    required this.icon,
  });

  final Color color;

  final EdgeInsets? padding;

  final Color textColor;

  final Color? loaderColor;

  final String label;

  final double fontSize;

  final double minSize;

  final bool enabled;

  final bool isLoading;

  final VoidCallback? onPressed;
  final Widget? icon;

  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: padding,
      color: color,
      disabledColor: color.withOpacity(0.8),
      onPressed: !enabled || isLoading ? null : onPressed,
      minSize: minSize,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      child: isLoading
          ? Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    strokeWidth: 3, color: loaderColor ?? color),
              ),
            )
          : FittedBox(
              fit: BoxFit.scaleDown,
              child: icon != null
                  ? Row(
                      children: [
                        icon!,
                        const SizedBox(
                          width: 10,
                        ),
                        text,
                      ],
                    )
                  : text,
            ),
    );
  }

  Text get text => Text(
        label,
        maxLines: 1,
        style: TextStyle(
            color: textColor,
            fontWeight: fontWeight ?? FontWeight.w500,
            fontSize: fontSize,
            fontFamily: kDefaultFont),
      );
}

class QSecondaryButton extends StatelessWidget {
  const QSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.fontSize = 14.5,
    this.width = 2,
    this.minSize = 50,
    this.color = kButtonColor,
    this.textColor,
    this.isLoading = false,
  });

  final String label;

  final VoidCallback? onPressed;

  final double fontSize;

  final double width;

  final double minSize;

  final Color color;

  final Color? textColor;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(minSize, minSize),
        side: BorderSide(color: color, width: 2),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
      onPressed: onPressed,
      child: isLoading
          ? Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: color,
                ),
              ),
            )
          : Text(
              label,
              style: TextStyle(
                color: textColor ?? color,
                fontWeight: FontWeight.w500,
                fontSize: fontSize,
              ),
            ),
    );
  }
}
