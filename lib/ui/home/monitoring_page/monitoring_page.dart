import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/book_room_parent/book_room_provider.dart';
import 'package:nursery/ui/home/monitoring_page/monitoring_provider.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:nursery/utils/colors.dart';
import 'package:provider/provider.dart';

class MonitoringPage extends StatelessWidget {
  final BookingRoom bookedRoomData;
  const MonitoringPage({super.key, required this.bookedRoomData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MonitoringProvider(
            bookedRoomData: bookedRoomData,
            firestore: GetIt.I<FirestoreService>()),
        builder: (context, snapshot) {
          MonitoringProvider provider = context.watch();
          return provider.isLoading
              ? const LoaderWidget()
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: kPrimaryColor,
                    title: Text("${provider.babyData?.fullname} Monitoring"),
                    centerTitle: true,
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: Text("Here I must CONTINue !!!"),
                      )
                    ],
                  ),
                );
        });
  }
}
