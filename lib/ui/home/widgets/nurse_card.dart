import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nursery/model/nurse.dart';
import 'package:nursery/utils/icons.dart';

class NurseCard extends StatelessWidget {
  final Nurse nurse;
  final VoidCallback onPressed;
  const NurseCard({super.key, required this.nurse, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                nurse.image != null
                    ? ClipOval(
                        child: Image.network(
                        nurse.image!,
                        width: 75,
                        height: 80,
                      ))
                    : SvgPicture.asset(kAlternateNurse, width: 75, height: 80,),
              ],
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
    );
  }
}
