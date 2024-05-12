import 'package:flutter/material.dart';
import 'package:nursery/model/nurse.dart';

class NurseCard extends StatelessWidget {
  final Nurse nurse;
  final VoidCallback onPressed;
  const NurseCard({super.key, required this.nurse, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}