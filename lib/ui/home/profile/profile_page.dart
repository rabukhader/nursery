import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/services/firebase_auth_service.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/nurses_rating_page/nurses_rating_page.dart';
import 'package:nursery/ui/home/profile/edit_profile.dart';
import 'package:nursery/ui/home/profile/profile_page_provider.dart';
import 'package:nursery/ui/login-sign-up/log_in_sign_up_page.dart';
import 'package:nursery/utils/colors.dart';
import 'package:nursery/utils/icons.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final UserType userType;
  const ProfilePage({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ProfilePageProvider(
            firestore: GetIt.I<FirestoreService>(),
            authStore: GetIt.I<AuthStore>(),
            authService: GetIt.I<FirebaseAuthService>()),
        builder: (context, snapshot) {
          ProfilePageProvider provider = context.watch();
          return provider.isLoading
              ? const LoaderWidget()
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: SvgPicture.asset(
                                      provider.getGender == 'female'
                                          ? kProfileFemale
                                          : kProfileMale)),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: kPrimaryColor),
                                child: const Icon(
                                  LineAwesomeIcons.alternate_pencil,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(provider.getEmail ?? "",
                            style: Theme.of(context).textTheme.headlineMedium),
                        Text("0${provider.getPhone ?? 0}",
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 20),

                        /// -- BUTTON
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                          onUpdate: provider.updateUser,
                                          isUpdating: provider.isUpdating,
                                          user: provider.userData)));

                              await provider.init();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                side: BorderSide.none,
                                shape: const StadiumBorder()),
                            child: const Text("Edit Profile",
                                style: TextStyle(color: kWhiteColor)),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        if (userType == UserType.parents)
                          ProfileMenuWidget(
                              title: "Rate Our Nurses",
                              icon: LineAwesomeIcons.nurse,
                              textColor: kPrimaryColor,
                              endIcon: false,
                              onPress: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NursesRatingPage()
                                            ));
                              }),
                        const Divider(),
                        const SizedBox(height: 10),

                        ProfileMenuWidget(
                            title: "Logout",
                            icon: LineAwesomeIcons.alternate_sign_out,
                            textColor: kPrimaryColor,
                            endIcon: false,
                            onPress: () async {
                              await provider.logOut();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginSignUpPage(
                                            isLogIn: true,
                                          )));
                            }),
                      ],
                    ),
                  ),
                );
        });
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    var iconColor = kPrimaryDarkerColor;

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconColor.withOpacity(0.1),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title,
          style:
              Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(LineAwesomeIcons.angle_right,
                  size: 18.0, color: Colors.grey))
          : null,
    );
  }
}
