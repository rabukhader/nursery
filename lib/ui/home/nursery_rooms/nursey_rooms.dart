import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/model/room.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/nursery_rooms/nursery_rooms_provider.dart';
import 'package:nursery/ui/home/widgets/empty_alternate.dart';
import 'package:nursery/ui/home/widgets/list_header.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:provider/provider.dart';

class NurseryRooms extends StatelessWidget {
  const NurseryRooms({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NurseryRoomsProvider(GetIt.I<FirestoreService>()),
        builder: (context, snapshot) {
          NurseryRoomsProvider provider = context.watch();
          return SingleChildScrollView(
            child: Column(
              children: [
                const ListHeader(header: "NurseryRooms"),
                provider.isLoading
                    ? const LoaderWidget()
                    : (provider.rooms != null && provider.rooms!.isNotEmpty)
                        ? ListView.builder(
                            itemCount: provider.rooms!.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return RoomCard(room: provider.rooms![index]);
                            },
                          )
                        : const EmptyAlternate(text: "No Rooms Here"),
              ],
            ),
          );
        });
  }
}

class RoomCard extends StatelessWidget {
  final Room room;
  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
