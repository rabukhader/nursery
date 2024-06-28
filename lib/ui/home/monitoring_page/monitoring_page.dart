import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:nursery/utils/colors.dart';

class MonitoringPage extends StatefulWidget {
  final String ip;
  const MonitoringPage({super.key, required this.ip});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  late VlcPlayerController _vlcViewController;

  @override
  void initState() {
    super.initState();
    _vlcViewController = VlcPlayerController.network(
      'rtmp://${widget.ip}/live/test', // Replace with your RTMP URL
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
    return Scaffold(
                appBar: AppBar(
                  backgroundColor: kPrimaryColor,
                  title: const Text("Monitoring"),
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
  }
}
