import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/services/firestore_service.dart';
import 'package:nursery/ui/home/book_room_parent/book_room_provider.dart';
import 'package:nursery/ui/home/monitoring_page/monitoring_provider.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:nursery/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:typed_data';
import 'dart:async';

class MonitoringPage extends StatefulWidget {
  final BookingRoom bookedRoomData;
  const MonitoringPage({super.key, required this.bookedRoomData});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final channel = IOWebSocketChannel.connect('ws://82.205.40.70:8765');
  final List<Uint8List> _frameBuffer = [];
  Uint8List? _currentFrame;
  Timer? _playbackTimer;

  @override
  void initState() {
    super.initState();

    // Listen to the WebSocket stream
    channel.stream.listen((data) {
      // Add incoming frames to the buffer
      if (_frameBuffer.length < 20) {
        _frameBuffer.add(Uint8List.fromList(data));
      }
    });

    // Set up a periodic timer to play frames from the buffer
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_frameBuffer.isNotEmpty) {
        setState(() {
          _currentFrame = _frameBuffer.removeAt(0);
        });
      }
    });
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MonitoringProvider(
            bookedRoomData: widget.bookedRoomData,
            firestore: GetIt.I<FirestoreService>()),
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
                    child: _currentFrame != null
                        ? Image.memory(_currentFrame!)
                        : const LoaderWidget(),
                  ),
                );
        });
  }
}
