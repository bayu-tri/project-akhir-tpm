import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MySimplePlayer extends StatefulWidget {
  const MySimplePlayer({Key? key, required this.asset});
  final String asset;

  @override
  _MySimplePlayerState createState() => _MySimplePlayerState();
}

class _MySimplePlayerState extends State<MySimplePlayer> {
  late AudioPlayer player;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    // player.setLoopMode(LoopMode.one);
    player.setUrl(widget.asset).then((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const SizedBox();

    return Card(
      elevation: 0,
      color: Colors.green[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 16),
          Expanded(
              child: Text(
            "Audio Player",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
          )),
          if (!player.playing)
            IconButton(
              color: Colors.green,
              icon: Icon(Icons.play_arrow),
              onPressed: () async {
                player.play();
                setState(() {});
              },
            ),
          if (player.playing)
            IconButton(
              color: Colors.green,
              icon: Icon(Icons.pause),
              onPressed: () async {
                await player.pause();
                setState(() {});
              },
            ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
