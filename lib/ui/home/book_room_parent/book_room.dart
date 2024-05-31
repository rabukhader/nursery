import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/book_room_parent/book_room_provider.dart';
import 'package:nursery/ui/home/forms/book_room_for_baby.dart';
import 'package:nursery/ui/home/monitoring_page/monitoring_page.dart';
import 'package:nursery/ui/home/widgets/empty_alternate.dart';
import 'package:nursery/ui/home/widgets/list_header.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:nursery/ui/home/widgets/room_card.dart';
import 'package:nursery/utils/toaster.dart';
import 'package:provider/provider.dart';

class BookRoom extends StatelessWidget {
  const BookRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => BookRoomProvider(GetIt.I<FirestoreService>()),
        builder: (context, snapshot) {
          BookRoomProvider provider = context.watch();
          return SingleChildScrollView(
            child: provider.isLoading
                ? const LoaderWidget()
                : Column(
                    children: [
                      const ListHeader(header: "Book Rooms"),
                      (provider.rooms != null && provider.rooms!.isNotEmpty)
                          ? SizedBox(
                              height: 200.0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: provider.rooms!.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return RoomCard(
                                      isNursery: false,
                                      bookRoom: () async {
                                        BookingRoom? result =
                                            await BookRomForBabyForm.show(
                                                context: context,
                                                userId:
                                                    provider.userData?.id ?? "",
                                                roomId:
                                                    provider.rooms![index].id,
                                                babies: provider
                                                    .getavailableBabies());
                                        if (result != null) {
                                          await provider.bookRoom(result);
                                          await provider.loadData();
                                        }
                                      },
                                      room: provider.rooms![index]);
                                },
                              ),
                            )
                          : const EmptyAlternate(text: "No Rooms Here"),
                      const ListHeader(header: "Where your babies ?"),
                      provider.bookedRooms != null &&
                              provider.bookedRooms!.isNotEmpty
                          ? SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: provider.bookedRooms!.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (isSameDate(
                                          provider.bookedRooms![index]
                                                  .bookingDate ??
                                              DateTime.now(),
                                          DateTime.now())) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => MonitoringPage(
                                                      bookedRoomDate: BookingRoom(
                                                          parentId: provider
                                                                  .userData
                                                                  ?.id ??
                                                              "",
                                                          roomId: provider
                                                              .bookedRooms![
                                                                  index]
                                                              .id,
                                                          babyId: provider
                                                                  .bookedRooms![
                                                                      index]
                                                                  .baby
                                                                  ?.id ??
                                                              "",
                                                          date: provider
                                                                  .bookedRooms![
                                                                      index]
                                                                  .bookingDate ??
                                                              DateTime.now()),
                                                    )));
                                      } else {
                                        ErrorUtils.showGeneralError(context,
                                            "This is not the time to watch");
                                      }
                                    },
                                    child: RoomCard(
                                        isNursery: false,
                                        room: provider.bookedRooms![index]),
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

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
