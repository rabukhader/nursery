import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/model/baby.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/forms/add_baby_form.dart';
import 'package:nursery/ui/home/widgets/add_new_card.dart';
import 'package:nursery/ui/home/widgets/empty_alternate.dart';
import 'package:nursery/ui/home/widgets/list_header.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:nursery/ui/home/parent_dashboard/parent_dashboard_provider.dart';
import 'package:nursery/utils/buttons.dart';
import 'package:nursery/utils/cache_picture.dart';
import 'package:nursery/utils/fallback_image_handler.dart';
import 'package:nursery/utils/icons.dart';
import 'package:nursery/utils/welcome_messages.dart';
import 'package:provider/provider.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {

  @override
  void didChangeDependencies(){
    precacheSvgPicture(kNurseryDashboard);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ParentDashboardProvider(
            GetIt.I<FirestoreService>(), GetIt.I<AuthStore>()),
        builder: (context, snapshot) {
          ParentDashboardProvider provider = context.watch();
          return SingleChildScrollView(
            child: Column(children: [
              
              Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      kAternateBabyBoy,
                      width: 45,
                      height: 45,
                    ),
                    provider.isLoadingBabies
                        ? const LoaderWidget()
                        : WordByWordAnimation(
                            gender: provider.userData?.gender ?? "male",
                            duration:
                                const Duration(seconds: 2, milliseconds: 500),
                          ),
                  ],
                ),
              ),
              Center(
                child: SvgPicture.asset(
                  kNurseryDashboard,
                  height: 200,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const ListHeader(header: "My Babies"),
              provider.isLoadingBabies
                  ? const LoaderWidget()
                  : (provider.babies != null && provider.babies!.isNotEmpty)
                      ? GridView.builder(
                          itemCount: provider.babies!.length,
                          shrinkWrap: true,
                          primary: false,
                          padding: const EdgeInsets.all(7),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 1),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return AddNewCard(
                                  title: "Add new baby",
                                  onAddNew: () async {
                                    Baby? baby = await AddNewBabyForm.show(
                                        context: context);
                                    if (baby != null) {
                                      await provider.addBaby(baby);
                                      await provider.loadData();
                                    }
                                  });
                            } else {
                              return BabyCard(
                                baby: provider.babies![index],
                                onPressed: () {},
                              );
                            }
                          },
                        )
                      : EmptyAlternate(
                          text: "No Babies",
                          image: SvgPicture.asset(
                            kNoNurses,
                            height: 250,
                          ),
                          forRefill: QPrimaryButton(
                            label: "Add New Baby",
                            onPressed: () async {
                              Baby? baby =
                                  await AddNewBabyForm.show(context: context);
                              if (baby != null) {
                                await provider.addBaby(baby);
                              }
                            },
                          ),
                        )
            ]),
          );
        });
  }
}

class BabyCard extends StatelessWidget {
  final Baby baby;
  final VoidCallback onPressed;
  const BabyCard({super.key, required this.baby, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 16,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  baby.gender == "male"?
                  FallbackImageHandler(
                    image: baby.image,
                    localSvgAlternate: kAternateBabyBoy,
                  ) : FallbackImageHandler(
                    image: baby.image,
                    localSvgAlternate: kAlternateBabyGirl,
                    fallbackNotSvg: true,
                  )
                ],
              ),
              Column(
                children: [
                  Text(baby.fullname ?? ""),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WordByWordAnimation extends StatefulWidget {
  final String gender;
  final Duration duration;

  const WordByWordAnimation({
    super.key,
    required this.gender,
    this.duration = const Duration(seconds: 2),
  });

  @override
  // ignore: library_private_types_in_public_api
  _WordByWordAnimationState createState() => _WordByWordAnimationState();
}

class _WordByWordAnimationState extends State<WordByWordAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  late List<String> _words;

  String getRandomWelcomingMessage(String gender) {
    final random = Random();

    if (gender.toLowerCase() == 'female') {
      return momMessages[random.nextInt(momMessages.length)];
    } else {
      return dadMessages[random.nextInt(dadMessages.length)];
    }
  }

  @override
  void initState() {
    super.initState();
    _words = getRandomWelcomingMessage(widget.gender).split(' ');
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward();

    _animation = IntTween(begin: 0, end: _words.length).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        String displayedText = _words.take(_animation.value).join(' ');
        return Text(displayedText, style: const TextStyle(fontSize: 16));
      },
    );
  }
}
