import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/model/user.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/ui/home/book_room/book_room.dart';
import 'package:nursery/ui/home/home_page_provider.dart';
import 'package:nursery/ui/home/nursery_dashboard/nursery_dashboard.dart';
import 'package:nursery/ui/home/nursery_rooms/nursey_rooms.dart';
import 'package:nursery/ui/home/profile/profile_page.dart';
import 'package:nursery/ui/home/parent_dashboard/parent_dashboard.dart';
import 'package:nursery/utils/colors.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final UserType userType;
  const HomePage({super.key, required this.userType});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomePageProvider(GetIt.I<AuthStore>()),
        builder: (context, snapshot) {
          HomePageProvider provider = context.watch();
          return Scaffold(
              appBar: AppBar(
                backgroundColor: kPrimaryColor,
                title: const Text("Nursery"),
                automaticallyImplyLeading: false,
                centerTitle: true,
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedPage,
                selectedItemColor: kPrimaryColor,
                unselectedItemColor: kPrimaryDarkerColor,
                onTap: (index) {
                  setState(() {
                    _selectedPage = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                      label: "Home", icon: Icon(Icons.home)),
                  BottomNavigationBarItem(
                      label: "Rooms", icon: Icon(Icons.bed)),
                  BottomNavigationBarItem(
                      label: "Profile", icon: Icon(Icons.person)),
                ],
              ),
              body: _buildScreenAt(context, _selectedPage));
        });
  }

  _buildScreenAt(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (widget.userType == UserType.nursery) {
          return const NurseryDashboard();
        } else {
          return const ParentDashboard();
        }
      case 1:
        if (widget.userType == UserType.nursery) {
          return const NurseryRooms();
        } else {
          return const BookRoom();
        }
      case 2:
        return const ProfilePage();
    }
  }
}
