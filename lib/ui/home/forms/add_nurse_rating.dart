import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nursery/model/nurse.dart';
import 'package:nursery/ui/home/nurses_rating_page/nurses_rating_provider.dart';
import 'package:nursery/utils/buttons.dart';
import 'package:nursery/utils/fallback_image_handler.dart';
import 'package:nursery/utils/icons.dart';
import 'package:nursery/utils/rating_bar.dart';

class NurseRatingDialog extends StatefulWidget {
  final Nurse nurse;
  const NurseRatingDialog({super.key, required this.nurse});

  @override
  State<NurseRatingDialog> createState() => _NurseRatingDialogState();
}

class _NurseRatingDialogState extends State<NurseRatingDialog> {
  final TextEditingController _feedback = TextEditingController();
  double _currentRating = 0.0;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: widget.nurse.rate != null
            ? MediaQuery.of(context).size.height * 0.8
            : MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                radius: 50,
                child: FallbackImageHandler(
                  image: widget.nurse.image,
                  localSvgAlternate: kAlternateNurse,
                ),
              ),
              Text(
                widget.nurse.fullname ?? "",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RatingBar.builder(
                        initialRating: _currentRating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _currentRating = rating;
                          });
                        },
                      )
                    ]),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _validateInput();
                  });
                },
                controller: _feedback,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your Feedback',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              QPrimaryButton(
                enabled: _validateInput(),
                onPressed: () {
                  Navigator.pop(
                      context,
                      NurseRating(
                          numberOfRatingUsers:
                              widget.nurse.numberOfRatingUsers ?? 0,
                          nurseId: widget.nurse.id,
                          feedback: _feedback.text,
                          rating: _currentRating));
                },
                label: 'Add Review',
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Feedbacks on Nurse : ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              (widget.nurse.feedback != null &&
                      widget.nurse.feedback!.isNotEmpty)
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Column(
                        children:
                            widget.nurse.feedback!.map((e) => Text(e)).toList(),
                      ),
                    )
                  : const Text("Still No Feedbacks, Be The First One"),
              if (widget.nurse.rate != null)
                FixedRatingBar(
                  rating: (widget.nurse.rate)!.toDouble(),
                  title: "Rating By Users",
                ),
            ],
          ),
        ),
      ),
    );
  }

  _validateInput() {
    return (_feedback.text.isNotEmpty && _currentRating != 0);
  }
}
