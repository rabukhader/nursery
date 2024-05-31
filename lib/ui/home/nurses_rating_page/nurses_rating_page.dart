import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/forms/add_nurse_rating.dart';
import 'package:nursery/ui/home/nurses_rating_page/nurses_rating_provider.dart';
import 'package:nursery/ui/home/widgets/empty_alternate.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:nursery/ui/home/widgets/nurse_card.dart';
import 'package:nursery/utils/colors.dart';
import 'package:provider/provider.dart';

class NursesRatingPage extends StatefulWidget {
  const NursesRatingPage({super.key});

  @override
  State<NursesRatingPage> createState() => _NursesRatingPageState();
}

class _NursesRatingPageState extends State<NursesRatingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text("Rate Our Nurse"),
      ),
      body: ChangeNotifierProvider(
        create: (_) =>
            NursesRatingProvider(firestore: GetIt.I<FirestoreService>()),
        builder: (context, snapshot) {
          NursesRatingProvider provider = context.watch();
          return provider.isLoading
              ? const LoaderWidget()
              : (provider.nurses != null && provider.nurses!.isNotEmpty)
                  ? GridView.builder(
                      itemCount: provider.nurses!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        return NurseCard(
                          nurse: provider.nurses![index],
                          onPressed: () async {
                            NurseRating? nurseRating = await showDialog(
                                context: context,
                                builder: (context) => NurseRatingDialog(
                                    nurse: provider.nurses![index]));
                            if (nurseRating != null) {
                              await provider.addRating(nurseRating);
                              await provider.loadData();
                            }
                          },
                        );
                      })
                  : const EmptyAlternate(text: "No Nurses");
        },
      ),
    );
  }
}

