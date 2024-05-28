import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nursery/utils/colors.dart';

class LoaderWidget extends StatelessWidget {
  final double? size;
  final double? height;
  final double? width;
  const LoaderWidget({super.key, this.size, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: LoadingAnimationWidget.bouncingBall(color: kPrimaryColor, size: size ?? 24),
      ),
    );
  }
}