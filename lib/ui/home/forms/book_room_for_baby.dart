import 'package:flutter/material.dart';
import 'package:nursery/model/baby.dart';
import 'package:nursery/ui/home/book_room_parent/book_room_provider.dart';
import 'package:nursery/ui/home/widgets/date_picker.dart';
import 'package:nursery/utils/buttons.dart';
import 'package:nursery/utils/colors.dart';
import 'package:nursery/utils/formatter.dart';

class BookRomForBabyForm extends StatefulWidget {
  static Future<dynamic> show(
      {required BuildContext context, required List<Baby> babies, required String roomId, required String userId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      builder: (context) => BookRomForBabyForm(babies: babies, roomId: roomId, userId: userId),
    );
  }

  final List<Baby> babies;
  final String roomId;
  final String userId;

  const BookRomForBabyForm({super.key, required this.babies, required this.roomId, required this.userId});

  @override
  State<BookRomForBabyForm> createState() => _BookRomForBabyFormState();
}

class _BookRomForBabyFormState extends State<BookRomForBabyForm> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  Baby? _selectedBaby;
  DateTime? _selectedDate = DateTime.now();

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
                                setState(() {
                                  _validateInput();
                                });
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
                            child: GestureDetector(
                              onTap: () async {
                                _selectedDate = await showDate(context);
                                setState(() {});
                              },
                              child: DatePicker(
                                date: Formatter.formatDateToString(
                                    _selectedDate ?? DateTime.now()),
                              ),
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
                                      BookingRoom(roomId: widget.roomId, babyId: _selectedBaby?.id ?? "", date: _selectedDate!,parentId: widget.userId )
                                    );
                                  })),
                        ],
                      ),
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

  _validateInput(){
    return (_selectedBaby != null);
  }

  Future<DateTime?> showDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: kBlackedColor,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: kPrimaryDarkerColor), // Number color
            ),
          ),
          child: DatePickerTheme(
            data: const DatePickerThemeData(
              backgroundColor: kPrimaryColor,
            ),
            child: child!,
          ),
        );
      },
    );
    return selectedDate;
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
