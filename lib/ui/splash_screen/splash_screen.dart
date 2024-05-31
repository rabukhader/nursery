import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/ui/home/home_page.dart';
import 'package:nursery/ui/login-sign-up/log_in_sign_up_page.dart';
import 'package:nursery/utils/cache_picture.dart';
import 'package:nursery/utils/colors.dart';
import 'package:nursery/utils/icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1500), () async {
      if (mounted) {
        await _onSplashCompleted();
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheSvgPicture(kLogoIcon);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kPrimaryColor, kLightOrangeColor])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                kLogoIcon,
                height: 350,
              ),
              const Text(
                "Layali",
                style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 44,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onSplashCompleted() async {
    User? user = await GetIt.I<AuthStore>().getUser();
    if (user != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    userType: user.type,
                  )),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (c) => const LoginSignUpPage(isLogIn: true)),
          (route) => false);
    }
  }
}
