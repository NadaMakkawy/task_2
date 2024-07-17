import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class SongWidget extends StatefulWidget {
  final Audio audio;

  const SongWidget({required this.audio, super.key});

  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool isPlaying = false;
  int valueEx = 0;

  @override
  void initState() {
    assetsAudioPlayer.open(widget.audio, autoStart: false);
    assetsAudioPlayer.isPlaying.listen((bool? isPlaying) {
      this.isPlaying = isPlaying ?? false;
    });

    assetsAudioPlayer.playSpeed.listen((event) {});

    assetsAudioPlayer.currentPosition.listen((event) {
      valueEx = event.inSeconds;
    });

    setState(() {});

    super.initState();
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: StreamBuilder(
          stream: assetsAudioPlayer.realtimePlayingInfos,
          builder: (ctx, snapShots) {
            if (snapShots.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapShots.data == null) {
              return const SizedBox.shrink();
            }
            return
                // Text(
                //   convertSeconds(snapShots.data?.duration.inSeconds ?? 0),
                // );
                Text(
              isPlaying
                  ? convertSeconds(valueEx)
                  : convertSeconds(snapShots.data?.duration.inSeconds ?? 0),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            );
          }),
      leading: CircleAvatar(
        child: Center(
          child: Text(
            '${widget.audio.metas.artist?.split(' ').first[0].toUpperCase()}${widget.audio.metas.artist?.split(' ').last[0].toUpperCase()}',
          ),
        ),
      ),
      title: Text(widget.audio.metas.title ?? 'No Title'),
      subtitle: Text(widget.audio.metas.artist ?? 'No Title'),
      onTap: () {
        if (isPlaying) {
          assetsAudioPlayer.pause();
        } else {
          // assetsAudioPlayer.play();
          assetsAudioPlayer.stop();
          assetsAudioPlayer.open(widget.audio, autoStart: true);
        }
        setState(() {
          isPlaying = !isPlaying;
        });
      },
    );
  }

  String convertSeconds(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String secondsStr = (seconds % 60).toString();
    return '${minutes.padLeft(2, '0')}:${secondsStr.padLeft(2, '0')}';
  }
}
