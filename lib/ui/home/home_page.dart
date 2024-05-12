import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/ui/home/home_page_provider.dart';
import 'package:nursery/ui/home/nursery_dashboard/nursery_dashboard.dart';
import 'package:nursery/ui/home/profile/profile_page.dart';
import 'package:nursery/utils/colors.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomePageProvider( GetIt.I<AuthStore>()),
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
                items:  const [
                  BottomNavigationBarItem(
                      label: "Home", icon: Icon(Icons.home)),
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
        return const NurseryDashboard();
      case 1:
        return const ProfilePage();
    }
  }
}