import 'package:flutter/material.dart';
import 'package:nursery/utils/colors.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel),
              ),
              const Text('App Information'),
            ],
          ),
          bottom: const TabBar(
            labelColor: kWhiteColor,
            tabs: [
              Tab(text: 'About the App'),
              Tab(text: 'Permissions'),
              Tab(text: 'How it Works'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AboutTab(),
            PermissionsTab(),
            HowItWorksTab(),
          ],
        ),
      ),
    );
  }
}

class AboutTab extends StatelessWidget {
  const AboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'This app is designed to help parents keep track of their baby\'s growth and milestones. It provides various tools and features to assist in day-to-day parenting tasks.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class PermissionsTab extends StatelessWidget {
  const PermissionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'This app requires the following permissions:\n\n- Camera: To take photos and videos.\n- Storage: To save and access photos and videos.\n- Location: To provide location-based services.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class HowItWorksTab extends StatelessWidget {
  const HowItWorksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'To use this app:\n\n1. Create an account or log in.\n2. Set up your baby\'s profile.\n3. Start tracking activities such as feeding, sleeping, and diaper changes.\n4. Use the app\'s tools and features to monitor your baby\'s growth and development.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
