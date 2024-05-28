import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/nursery_rooms/nursery_rooms_provider.dart';
import 'package:nursery/ui/home/widgets/empty_alternate.dart';
import 'package:nursery/ui/home/widgets/list_header.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:nursery/ui/home/widgets/room_card.dart';
import 'package:nursery/utils/buttons.dart';
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
                const ListHeader(header: "Nursery Empty Rooms"),
                provider.isAddingRoom
                    ? const LoaderWidget(
                      height: 200,
                    )
                    : provider.rooms != null && provider.rooms!.isNotEmpty
                        ? Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: provider.rooms!.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return RoomCard(
                                    isNursery: true,
                                    room: provider.rooms![index]);
                              },
                            ),
                          )
                        : const EmptyAlternate(text: "No Rooms"),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: QPrimaryButton(
                              isLoading: provider.isAddingRoom,
                          color: kGoldenYellowColor,
                          textColor: kBlackedColor,
                          onPressed: () async {
                            await provider.addRoom();
                          },
                          label: "Add More Rooms",
                        ))
                      ],
                    )),
                const SizedBox(
                  height: 16.0,
                ),
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
                                  isNursery: true,
                                  room: provider.bookedRooms![index],
                                  viewRoom: () {},
                                );
                              },
                            ),
                          )
                        : const EmptyAlternate(text: "No Booked Rooms"),
              ],
            ),
          );
        });
  }
}
