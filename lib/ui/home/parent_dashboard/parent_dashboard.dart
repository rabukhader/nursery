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
import 'package:nursery/utils/fallback_image_handler.dart';
import 'package:nursery/utils/icons.dart';
import 'package:provider/provider.dart';

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ParentDashboardProvider(
            GetIt.I<FirestoreService>(), GetIt.I<AuthStore>()),
        builder: (context, snapshot) {
          ParentDashboardProvider provider = context.watch();
          return SingleChildScrollView(
            child: Column(children: [
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
                              Baby? baby =
                                  await AddNewBabyForm.show(context: context);
                              if (baby != null) {
                                await provider.addBaby(baby);
                              }
                            }
                              );
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
                  FallbackImageHandler(
                    image: baby.image,
                    localSvgAlternate: kAternateBay,
                  )
                ],
              ),
              Column(
                children: [
                  Text(baby.fullname ?? ""),
                  Text(baby.gender ?? ""),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
