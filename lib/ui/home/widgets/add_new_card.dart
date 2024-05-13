import 'package:flutter/material.dart';
import 'package:nursery/utils/colors.dart';

class AddNewCard extends StatelessWidget {
  final VoidCallback onAddNew;
  final String title;
  const AddNewCard({super.key, required this.onAddNew, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                onAddNew();
              },
              child: ClipOval(
                child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: kPrimaryColor, width: 2.0)),
                    child: const Icon(Icons.add)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(title)
          ],
        ),
      ),
    );
  }
}