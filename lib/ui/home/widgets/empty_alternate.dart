import 'package:flutter/material.dart';

class EmptyAlternate extends StatelessWidget {
  final Widget? image;
  final String text;
  final Widget? forRefill;
  const EmptyAlternate(
      {super.key, this.image, required this.text, this.forRefill});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        image ?? const SizedBox(),
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(text),
          ),
        ),
        forRefill ?? const SizedBox()
      ],
    );
  }
}
