import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/model/nurse.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/forms/add_nurse_form.dart';
import 'package:nursery/ui/home/nurse_view_page/nurse_view.dart';
import 'package:nursery/ui/home/nursery_dashboard/nursery_dashboard_provider.dart';
import 'package:nursery/ui/home/widgets/add_new_card.dart';
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
            NurseryDashboardProvider(firestore: GetIt.I<FirestoreService>()),
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
                                  itemCount: provider.nurses!.length,
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: const EdgeInsets.all(7),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 1),
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return AddNewCard(
                                        title: "Add New Nurse",
                                        onAddNew: () async {
                                          Nurse? nurse =
                                              await AddNewNurseForm.show(
                                                  context: context);
                                          if (nurse != null) {
                                            await provider.addNurse(nurse);
                                            await provider.loadData();
                                          }
                                        },
                                      );
                                    } else {
                                      return NurseCard(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => NurseViewPage(
                                                        isSaving:
                                                            provider.isSaving,
                                                        nurse: provider
                                                            .nurses![index],
                                                        onDelete: () async {
                                                          await provider
                                                              .deleteNurse(
                                                                  provider
                                                                      .nurses![
                                                                          index]
                                                                      .id);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        onSave: () async {
                                                          // await provider
                                                          //     .updateNurseData();
                                                        },
                                                      )));
                                        },
                                        nurse: provider.nurses![index],
                                      );
                                    }
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
                                    onPressed: () async {
                                      Nurse? nurse = await AddNewNurseForm.show(
                                          context: context);
                                      if (nurse != null) {
                                        await provider.addNurse(nurse);
                                      }
                                      await provider.loadData();
                                    },
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
