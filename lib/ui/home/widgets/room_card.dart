import 'package:flutter/material.dart';
import 'package:nursery/model/room.dart';
import 'package:nursery/utils/colors.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback? bookRoom;
  final VoidCallback? viewRoom;
  const RoomCard({super.key, required this.room, this.bookRoom, this.viewRoom});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
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
                    Text("Room Number : ${room.roomNumber}"),
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
                        const SizedBox(height: 16,),
                        const Text("Book Room For You Baby", textAlign: TextAlign.center,)
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Room Number ${room.roomNumber} ,Filled with : ${room.baby?.fullname}",
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