import 'package:flutter/material.dart';
import 'package:nursery/model/nurse.dart';
import 'package:nursery/ui/home/widgets/list_header.dart';
import 'package:nursery/utils/buttons.dart';
import 'package:nursery/utils/colors.dart';
import 'package:nursery/utils/fallback_image_handler.dart';
import 'package:nursery/utils/icons.dart';
import 'package:nursery/utils/rating_bar.dart';

class NurseViewPage extends StatelessWidget {
  final Nurse nurse;
  final VoidCallback onDelete;
  final VoidCallback onSave;
  final bool isSaving;
  const NurseViewPage(
      {super.key,
      required this.nurse,
      required this.onDelete,
      required this.onSave,
      required this.isSaving});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(nurse.fullname ?? ""),
        actions: [
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
          QPrimaryButton(
            label: "Save",
            onPressed: onSave,
            isLoading: isSaving,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipOval(
                child: FallbackImageHandler(
                  width: 120,
                  height: 140,
                  image: nurse.image,
                  localSvgAlternate: kAlternateNurse,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Nurse name : ${nurse.fullname ?? ""}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            Text("Nurse Number : 0${nurse.userNumber}",
                style: const TextStyle(fontSize: 14)),
            FixedRatingBar(
              rating: (nurse.rate ?? 3.0).toDouble(),
              title: "Rating By Users",
            ),
            if (nurse.feedback != null && nurse.feedback!.isNotEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 22,
                  ),
                  const ListHeader(header: "Feedback"),
                  ...nurse.feedback!.map((e) => Container(
                      margin: EdgeInsets.only(left: 22), child: Text(e)))
                ],
              )
          ],
        ),
      ),
    );
  }
}
