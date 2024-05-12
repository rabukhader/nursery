import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nursery/model/nurse.dart';
import 'package:nursery/ui/login-sign-up/log_in_sign_up_page.dart';
import 'package:nursery/utils/buttons.dart';
import 'package:nursery/utils/colors.dart';
import 'package:nursery/utils/validators.dart';
import 'package:uuid/uuid.dart';

class AddNewNurseForm extends StatefulWidget {
  static Future<dynamic> show({required BuildContext context}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      builder: (context) => const AddNewNurseForm(),
    );
  }

  const AddNewNurseForm({super.key});

  @override
  State<AddNewNurseForm> createState() => _AddNewNurseFormState();
}

class _AddNewNurseFormState extends State<AddNewNurseForm> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  Gender _selectedGender = Gender.male;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String? image;

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    image = null;
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  padding:
                      const EdgeInsets.only(top: 7, bottom: 7, right: 8, left: 8),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0xFFc1c1c1), width: 1.5))),
                  child: const _Title(title: "Add Nurse"),
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
                            "Full Name",
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
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  _formState.currentState!.validate();
                                  _validateInput();
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                }
                                if (!Validator.isFullNameValid(value)) {
                                   return "Please enter a valid Full Name";
                                }
                                return null;
                              },
                              controller: _fullName,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Full Name",
                                  hintStyle: TextStyle(color: kPrimaryDarkerColor)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Phone Number",
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
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  _formState.currentState!.validate();
                                  _validateInput();
                                });
                              },
                              keyboardType: TextInputType.number,
                              controller: _phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                }
                                if (!Validator.phoneNumerValidation(value)) {
                                  return "Please enter a valid Phone Number";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Phone Number",
                                  hintStyle: TextStyle(color: kPrimaryDarkerColor)),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Radio<Gender>(
                              activeColor: kPrimaryColor,
                              value: Gender.male,
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value ?? Gender.male;
                                });
                              },
                            ),
                            const Text("Male"),
                            const SizedBox(width: 20),
                            Radio<Gender>(
                              activeColor: kPrimaryColor,
                              value: Gender.female,
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value ?? Gender.male;
                                });
                              },
                            ),
                            const Text('Female'),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: QPrimaryButton(
                              label: "Add Photos",
                              onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Choose an image source"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          String link =
                                              await pickImage(ImageSource.camera);
                                          if (link != "false") {
                                            image = link;
                                          }
                                          setState(() {});
                                        },
                                        child: const Text("Camera"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          String link =
                                              await pickImage(ImageSource.gallery);
                                          if (link != "false") {
                                            image = link;
                                          }
                                          setState(() {});
                                        },
                                        child: const Text("Gallery"),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          if(image != null) Image.asset(image! , width: MediaQuery.of(context).size.width*0.3,)
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: QPrimaryButton(
                                  label: "Add Nurse",
                                  enabled: _validateInput(),
                                  onPressed: () async {
                                    Navigator.pop(
                                        context,
                                        Nurse(
                                            id: const Uuid().v4(),
                                            userNumber: int.parse(_phone.text),
                                            fullname: _fullName.text,
                                            gender: getGender(),
                                            image: image));
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
    return (_fullName.text.isNotEmpty && _phone.text.isNotEmpty);
  }

  Future<String> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final projectLogo = File(pickedFile.path);
      String url = await uploadImageToStorage(projectLogo);
      return url;
    } else {
      print('not used correctly');
      return "false";
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('cars/${DateTime.now()}.png');
    UploadTask uploadTask = storageRef.putFile(imageFile);
    await uploadTask.whenComplete(() {});
    final imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }

  String getGender() {
    switch (_selectedGender) {
      case Gender.male:
        return "male";
      case Gender.female:
        return "female";
      default:
        return "";
    }
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
