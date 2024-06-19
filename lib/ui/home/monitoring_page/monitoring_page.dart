import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/book_room_parent/book_room_provider.dart';
import 'package:nursery/ui/home/monitoring_page/monitoring_provider.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:nursery/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class MonitoringPage extends StatefulWidget {
  final BookingRoom bookedRoomData;
  const MonitoringPage({super.key, required this.bookedRoomData});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('rtmp://192.168.1.217:8080/hls/test.m3u8'),
    )..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
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
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}
