import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/book_room/book_room_provider.dart';
import 'package:nursery/ui/home/widgets/empty_alternate.dart';
import 'package:nursery/ui/home/widgets/list_header.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:provider/provider.dart';

class BookRoom extends StatelessWidget {
  const BookRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => BookRoomprovider(GetIt.I<FirestoreService>()),
        builder: (context, snapshot) {
          BookRoomprovider provider = context.watch();
          return SingleChildScrollView(
            child: provider.isLoading
                ? const LoaderWidget()
                : Column(
                    children: [
                      const ListHeader(header: "Book Rooms"),
                      (provider.rooms != null && provider.rooms!.isNotEmpty)
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: provider.rooms!.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return UserRoomCard();
                              },
                            )
                          : const EmptyAlternate(text: "No Rooms Here"),
                      const ListHeader(header: "Already Booked Rooms"),
                      provider.bookedRooms != null &&
                              provider.bookedRooms!.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: provider.bookedRooms!.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return UserRoomCard();
                              },
                            )
                          : const EmptyAlternate(text: "No Booked Rooms")
                    ],
                  ),
          );
        });
  }
}

class UserRoomCard extends StatelessWidget {
  const UserRoomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
