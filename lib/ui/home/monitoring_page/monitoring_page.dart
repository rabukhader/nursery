import 'package:flutter/material.dart';
import 'package:nursery/ui/home/book_room_parent/book_room_provider.dart';
import 'package:nursery/ui/home/monitoring_page/monitoring_provider.dart';
import 'package:provider/provider.dart';

class MonitoringPage extends StatelessWidget {
  final BookingRoom bookedRoomDate;
  const MonitoringPage({super.key, required this.bookedRoomDate});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MonitoringProvider(),
        builder: (context, snapshot) {
          MonitoringProvider provider = context.watch();
          return Scaffold(
            appBar: AppBar(
              title: const Text("Baby Name Monitoring"),
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
