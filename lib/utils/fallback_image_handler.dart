import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FallbackImageHandler extends StatelessWidget {
  final String? image;
  final String localSvgAlternate;
  final double? width;
  final double? height;
  final bool? fallbackNotSvg;
  const FallbackImageHandler(
      {super.key,
      this.image,
      required this.localSvgAlternate,
      this.width,
      this.height,
      this.fallbackNotSvg});

  @override
  Widget build(BuildContext context) {
    return image != null
        ? ClipOval(
            child: Image.network(
            image!,
            width: width ?? 75,
            height: height ?? 80,
          ))
        : fallbackNotSvg == true
            ? Image.asset(
                localSvgAlternate,
                width: width ?? 75,
                height: height ?? 80,
              )
            : SvgPicture.asset(
                localSvgAlternate,
                width: width ?? 75,
                height: height ?? 80,
              );
  }
}
