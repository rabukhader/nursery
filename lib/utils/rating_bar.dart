import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nursery/utils/colors.dart';

class FixedRatingBar extends StatefulWidget {
  final double rating;
  final String title;
  const FixedRatingBar({super.key, required this.rating, required this.title});

  @override
  State<FixedRatingBar> createState() => _FixedRatingBarState();
}

class _FixedRatingBarState extends State<FixedRatingBar> {
  final bool _isVertical = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40.0),
        _heading(widget.title),
        RatingBarIndicator(
          rating: widget.rating,
          itemBuilder: (context, index) => const Icon(
            Icons.star,
            color: kPrimaryColor,
          ),
          itemCount: 5,
          itemSize: 50.0,
          unratedColor: kPrimaryDarkerColor.withOpacity(0.1),
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
        ),
      ],
    );
  }

  Widget _heading(String text) => Column(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      );
}
