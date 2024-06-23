// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/services/firebase_auth_service.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/app_info_page/app_info_page.dart';
import 'package:nursery/ui/home/home_page.dart';
import 'package:nursery/ui/login-sign-up/log_in_sign_up_provider.dart';
import 'package:nursery/utils/buttons.dart';
import 'package:nursery/utils/colors.dart';
import 'package:nursery/utils/icons.dart';
import 'package:nursery/utils/toaster.dart';
import 'package:nursery/utils/validators.dart';
import 'package:provider/provider.dart';

class LoginSignUpPage extends StatefulWidget {
  final bool isLogIn;
  const LoginSignUpPage({super.key, required this.isLogIn});

  @override
  State<LoginSignUpPage> createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  bool isLogIn = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  Gender _selectedGender = Gender.male;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  void initState() {
    isLogIn = widget.isLogIn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LoginSignupProvider(
            authStore: GetIt.I<AuthStore>(),
            authService: GetIt.I<FirebaseAuthService>(),
            firestoreService: GetIt.I<FirestoreService>()),
        builder: (context, snapshot) {
          LoginSignupProvider provider = context.watch();
          return Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 300,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  kPrimaryColor, BlendMode.srcIn),
                              image: AssetImage(kLoginBackground),
                              fit: BoxFit.fill)),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 30,
                            width: 80,
                            height: 200,
                            child: FadeInUp(
                                duration: const Duration(seconds: 1),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(kLight1))),
                                )),
                          ),
                          Positioned(
                            left: 140,
                            width: 80,
                            height: 150,
                            child: FadeInUp(
                                duration: const Duration(milliseconds: 1200),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(kLight2))),
                                )),
                          ),
                          Positioned(
                            right: 40,
                            top: 40,
                            width: 80,
                            height: 150,
                            child: FadeInUp(
                                duration: const Duration(milliseconds: 1300),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(kLight2))),
                                )),
                          ),
                          Positioned(
                            child: FadeInUp(
                                duration: const Duration(milliseconds: 1600),
                                child: Container(
                                  margin:
                                      EdgeInsets.only(top: isLogIn ? 50 : 20),
                                  child: Center(
                                    child: Text(
                                      isLogIn ? "Login" : "Sign Up",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        children: <Widget>[
                          FadeInUp(
                              duration: const Duration(milliseconds: 1800),
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                kPrimaryColor.withOpacity(0.6),
                                            blurRadius: 20.0,
                                            offset: const Offset(0, 10))
                                      ]),
                                  child:
                                      isLogIn ? _loginForm() : _signUpForm())),
                          const SizedBox(
                            height: 30,
                          ),
                          FadeInUp(
                              duration: const Duration(milliseconds: 1900),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: QPrimaryButton(
                                    isLoading: provider.isLoggingIn,
                                    enabled: _validateInput(),
                                    label: isLogIn ? "Login" : "Sign Up",
                                    onPressed: isLogIn
                                        ? () async {
                                            String result =
                                                await provider.login(
                                                    _email.text,
                                                    _password.text);
                                            if (result == "pass") {
                                              manageNavigation(_email.text);
                                            } else {
                                              ErrorUtils.showMessage(
                                                  context, result,
                                                  backgroundColor: Colors.red
                                                  );
                                            }
                                          }
                                        : () async {
                                            String result =
                                                await provider.signup(
                                                    _email.text,
                                                    _password.text,
                                                    _fullName.text,
                                                    int.parse(_phone.text),
                                                    getGender());
                                            if (result == "pass") {
                                              manageNavigation(_email.text);
                                            } else {
                                              ErrorUtils.showMessage(
                                                  context, result,
                                                  backgroundColor: Colors.red);
                                            }
                                          },
                                  )),
                                ],
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          FadeInUp(
                              duration: const Duration(milliseconds: 2000),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    isLogIn = !isLogIn;
                                    clear();
                                  });
                                },
                                child: Text(
                                  isLogIn
                                      ? "Create new account ? Go to Sign up"
                                      : "Already have account ? Go to logIn",
                                  style: const TextStyle(color: kPrimaryColor),
                                ),
                              )),
                          FadeInUp(
                              duration: const Duration(milliseconds: 2100),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AppInfoPage()));
                                },
                                child: const Text(
                                  "About Basma",
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }

  _loginForm() {
    return Form(
      key: _formState,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  _formState.currentState!.validate();
                  _validateInput();
                });
              },
              controller: _email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                if (!Validator.emailFieldValidation(value)) {
                  return "Please enter a valid email";
                }
                return null;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
                  hintStyle: TextStyle(color: kPrimaryDarkerColor)),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  _validateInput();
                });
              },
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                  hintStyle: TextStyle(color: kPrimaryDarkerColor)),
            ),
          )
        ],
      ),
    );
  }

  _signUpForm() {
    return Form(
      key: _formState,
      child: Column(
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
                if (!Validator.isFullNameValid(value)) {
                  return "Please enter a valid Full name";
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
                if (!Validator.emailFieldValidation(value)) {
                  return "Please enter a valid email";
                }
                return null;
              },
              controller: _email,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
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
                if (!Validator.validatePassword(value)) {
                  return "Please enter a valid Password";
                }
                return null;
              },
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
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
              controller: _confirmPassword,
              obscureText: true,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Confirm Password",
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
      ),
    );
  }

  void manageNavigation(String email) {
    if (email.contains('nursery')) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage(
                    userType: UserType.nursery,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage(
                    userType: UserType.parents,
                  )));
    }
  }

  bool _validateInput() {
    if (widget.isLogIn) {
      if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      if (_email.text.isNotEmpty &&
          _password.text.isNotEmpty &&
          _confirmPassword.text.isNotEmpty &&
          _phone.text.isNotEmpty &&
          _fullName.text.isNotEmpty) {
        if (_password.text == _confirmPassword.text) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
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

  clear() {
    _email.clear();
    _password.clear();
    _confirmPassword.clear();
    _fullName.clear();
    _phone.clear();
  }
}

enum Gender {
  male,
  female,
}
