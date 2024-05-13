import 'package:flutter/material.dart';
import 'package:nursery/model/nurse.dart';
import 'package:nursery/utils/fallback_image_handler.dart';
import 'package:nursery/utils/icons.dart';

class NurseCard extends StatelessWidget {
  final Nurse nurse;
  final VoidCallback onPressed;
  const NurseCard({super.key, required this.nurse, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 16,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [FallbackImageHandler(image: nurse.image, localSvgAlternate: kAlternateNurse,)],
              ),
              Column(
                children: [
                  Text(nurse.fullname ?? ""),
                  Text("0${nurse.userNumber}"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
