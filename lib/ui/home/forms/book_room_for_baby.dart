import 'package:flutter/material.dart';
import 'package:nursery/model/baby.dart';
import 'package:nursery/utils/buttons.dart';
import 'package:nursery/utils/colors.dart';

class AddNewBabyForm extends StatefulWidget {
  static Future<dynamic> show(
      {required BuildContext context, required List<Baby> babies}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      builder: (context) => AddNewBabyForm(babies: babies),
    );
  }

  final List<Baby> babies;

  const AddNewBabyForm({super.key, required this.babies});

  @override
  State<AddNewBabyForm> createState() => _AddNewBabyFormState();
}

class _AddNewBabyFormState extends State<AddNewBabyForm> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  Baby? _selectedBaby;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Form(
            key: _formState,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.only(
                      top: 7, bottom: 7, right: 8, left: 8),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color(0xFFc1c1c1), width: 1.5))),
                  child: const _Title(title: "Book Room For Baby"),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Add Baby",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.55,
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<Baby>(
                              value: _selectedBaby,
                              onChanged: (value) {
                                _selectedBaby = value;
                              },
                              items: widget.babies
                                  .map<DropdownMenuItem<Baby>>(
                                    (Baby value) => DropdownMenuItem<Baby>(
                                      value: value,
                                      child: Text(value.fullname ?? ""),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: QPrimaryButton(
                                  label: "Book Room",
                                  enabled: _validateInput(),
                                  onPressed: () async {
                                    Navigator.pop(
                                      context,
                                    );
                                  })),
                        ],
                      ),
                      const SizedBox(height: 22),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validateInput() {
    // return (_fullName.text.isNotEmpty);
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kBlackedColor)),
        ),
        Container(
          width: 60,
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: kBlackedColor,
            ),
          ),
        ),
      ],
    );
  }
}
