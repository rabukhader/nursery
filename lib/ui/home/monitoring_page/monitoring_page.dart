import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/book_room_parent/book_room_provider.dart';
import 'package:nursery/ui/home/monitoring_page/monitoring_provider.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:nursery/utils/colors.dart';
import 'package:provider/provider.dart';

class MonitoringPage extends StatefulWidget {
  final BookingRoom bookedRoomData;
  const MonitoringPage({super.key, required this.bookedRoomData});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  late VlcPlayerController _vlcViewController;

  @override
  void initState() {
    super.initState();
    _vlcViewController = VlcPlayerController.network(
      'rtmp://192.168.1.217/live/test', // Replace with your RTMP URL
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(3000), // 3 seconds caching
          VlcAdvancedOptions.clockJitter(300), // Adjust as necessary
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true), // Force using TCP
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _vlcViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MonitoringProvider(
        bookedRoomData: widget.bookedRoomData,
        firestore: GetIt.I<FirestoreService>(),
      ),
      builder: (context, snapshot) {
        MonitoringProvider provider = context.watch();
        return provider.isLoading
            ? const LoaderWidget()
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: kPrimaryColor,
                  title: Text("${provider.babyData?.fullname} Monitoring"),
                  centerTitle: true,
                ),
                body: Center(
                  child: VlcPlayer(
                    controller: _vlcViewController,
                    aspectRatio: 16 / 9,
                    placeholder:
                        const Center(child: CircularProgressIndicator()),
                  ),
                ));
      },
    );
  }
}
