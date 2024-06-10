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
  final channel = IOWebSocketChannel.connect('ws://192.168.1.217:8765');
  Uint8List? _bytes;
  final _frameBuffer = <Uint8List>[];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    channel.stream.listen((data) {
      if (_frameBuffer.length < 10) { // Buffer up to 10 frames
        _frameBuffer.add(Uint8List.fromList(data));
      }
    });

    _timer = Timer.periodic(const Duration(milliseconds: 33), (timer) {
      if (_frameBuffer.isNotEmpty) {
        setState(() {
          _bytes = _frameBuffer.removeAt(0);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
                    child: _bytes != null
                        ? Image.memory(_bytes!)
                        : const LoaderWidget(),
                  ),
                );
        });
  }
}
