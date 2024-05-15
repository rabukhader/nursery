import 'package:flutter/material.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/ui/login-sign-up/log_in_sign_up_page.dart';
import 'package:nursery/utils/buttons.dart';
import 'package:nursery/utils/colors.dart';
import 'package:nursery/utils/validators.dart';

class EditProfile extends StatefulWidget {
  final User? user;
  final bool isUpdating;
  final Future<void> Function(
      {String? fullname, String? gender, int? userNumber}) onUpdate;
  const EditProfile(
      {super.key, this.user, required this.isUpdating, required this.onUpdate});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  Gender _selectedGender = Gender.male;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  void initState() {
    _phone.text = "0${widget.user?.userNumber ?? ''}";
    _fullName.text = widget.user?.fullname ?? '';
    _selectedGender =
        widget.user?.gender == "male" ? Gender.male : Gender.female;
    _validateInput();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text("Information"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          QPrimaryButton(
              isLoading: widget.isUpdating,
              loaderColor: kWhiteColor,
              enabled: _validateInput(),
              onPressed: () async {
                await widget.onUpdate(
                    fullname: _fullName.text,
                    gender: getGender(),
                    userNumber: int.parse(_phone.text));
                Navigator.pop(context);
              },
              label: "Save")
        ],
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.cancel)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formState,
          child: Column(
            children: [
              Column(
                children: [
                  Container(
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
                        return null;
                      },
                      controller: _fullName,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Full name",
                          hintStyle: TextStyle(color: kPrimaryDarkerColor)),
                    ),
                  ),
                  Container(
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
                ],
              )
            ],
          ),
        ),
      ),
    );
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

  _validateInput() {
    if (_fullName.text.isNotEmpty && _phone.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
