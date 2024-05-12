import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/services/firebase_service.dart';
import 'package:nursery/ui/home/nursery_dashboard/nursery_dashboard_provider.dart';
import 'package:nursery/ui/home/widgets/list_header.dart';
import 'package:nursery/ui/home/widgets/empty_alternate.dart';
import 'package:nursery/utils/buttons.dart';
import 'package:nursery/utils/icons.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:nursery/ui/home/widgets/nurse_card.dart';
import 'package:provider/provider.dart';

class NurseryDashboard extends StatelessWidget {
  const NurseryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) =>
            NurseryDashboardProvider(firebase: GetIt.I<FirebaseService>()),
        builder: (context, snapshot) {
          NurseryDashboardProvider provider = context.watch();
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: SvgPicture.asset(
                  kNurseryDashboard,
                  height: 200,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const ListHeader(
                        header: "Nurses List",
                      ),
                      provider.isLoading
                          ? const LoaderWidget()
                          : (provider.nurses != null &&
                                  provider.nurses!.isNotEmpty)
                              ? GridView.builder(
                                  itemCount: 5,
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: const EdgeInsets.all(7),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 1),
                                  itemBuilder: (context, index) {
                                    return NurseCard(
                                      onPressed: () {},
                                      nurse: provider.nurses![index],
                                    );
                                  },
                                )
                              : EmptyAlternate(
                                  text: "No Nurses",
                                  image: SvgPicture.asset(
                                    kNoNurses,
                                    height: 250,
                                  ),
                                  forRefill: QPrimaryButton(
                                    label: "Add New Nurse",
                                    onPressed: () {},
                                  ),
                                )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
