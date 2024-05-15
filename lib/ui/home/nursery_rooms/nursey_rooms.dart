import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/model/room.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/nursery_rooms/nursery_rooms_provider.dart';
import 'package:nursery/ui/home/widgets/empty_alternate.dart';
import 'package:nursery/ui/home/widgets/list_header.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:nursery/utils/colors.dart';
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
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListHeader(header: "Nursery booked Rooms"),
                provider.isLoading
                    ? const LoaderWidget()
                    : (provider.bookedRooms != null &&
                            provider.bookedRooms!.isNotEmpty)
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, childAspectRatio: 1),
                              itemCount: provider.bookedRooms!.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return RoomCard(
                                  room: provider.bookedRooms![index],
                                  viewRoom: () {},
                                );
                              },
                            ),
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
  final VoidCallback? bookRoom;
  final VoidCallback? viewRoom;
  const RoomCard({super.key, required this.room, this.bookRoom, this.viewRoom});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: room.isEmpty ? bookRoom : viewRoom,
        child: Card(
          color: kCloudyBlueColor,
          child: room.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Empty Room"),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: kPrimaryColor, width: 2.0)),
                        child: const Icon(Icons.add)),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Room Filled with ${room.baby?.fullname} Baby",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "At ${room.bookingDate}",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
