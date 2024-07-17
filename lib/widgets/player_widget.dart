import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlayerWidget extends StatefulWidget {
  final Playlist playlist;
  const PlayerWidget({required this.playlist, super.key});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  int valueEx = 0;
  double volumeEx = 1.0;
  double playSpeedEx = 1.0;

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    await assetsAudioPlayer.open(widget.playlist,
        autoStart: false, loopMode: LoopMode.playlist);
    assetsAudioPlayer.playSpeed.listen((event) {
      if (kDebugMode) {
        print('>>>>>$event');
      }
    });

    assetsAudioPlayer.volume.listen((event) {
      volumeEx = event;
    });
    assetsAudioPlayer.currentPosition.listen((event) {
      valueEx = event.inSeconds;
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 500,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Center(
              child: StreamBuilder(
                  stream: assetsAudioPlayer.realtimePlayingInfos,
                  builder: (context, snapShots) {
                    if (snapShots.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            assetsAudioPlayer.getCurrentAudioTitle == ''
                                ? 'please play your songs'
                                : assetsAudioPlayer.getCurrentAudioTitle,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: snapShots.data?.current?.index == 0
                                      ? null
                                      : () {
                                          assetsAudioPlayer.previous();
                                        },
                                  icon: const Icon(Icons.skip_previous)),
                              getBtnWIdget,
                              IconButton(
                                  onPressed: snapShots.data?.current?.index ==
                                          (assetsAudioPlayer.playlist?.audios
                                                      .length ??
                                                  0) -
                                              1
                                      ? null
                                      : () {
                                          assetsAudioPlayer.next();
                                        },
                                  icon: const Icon(Icons.skip_next)),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Column(
                            children: [
                              const Text(
                                'Volume',
                                style: TextStyle(color: Colors.black),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SegmentedButton(
                                      style: SegmentedButton.styleFrom(
                                          backgroundColor: Colors.amber),
                                      onSelectionChanged: (values) {
                                        volumeEx = values.first.toDouble();
                                        assetsAudioPlayer.setVolume(volumeEx);
                                        setState(() {});
                                      },
                                      segments: const [
                                        ButtonSegment(
                                          icon: Icon(Icons.volume_up),
                                          value: 1.0,
                                        ),
                                        ButtonSegment(
                                          icon: Icon(Icons.volume_down),
                                          value: 0.5,
                                        ),
                                        ButtonSegment(
                                          icon: Icon(Icons.volume_mute),
                                          value: 0,
                                        ),
                                      ],
                                      selected: {
                                        volumeEx
                                      }),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text(
                                'Speed',
                                style: TextStyle(color: Colors.black),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SegmentedButton(
                                      style: SegmentedButton.styleFrom(
                                          backgroundColor: Colors.amber),
                                      onSelectionChanged: (values) {
                                        playSpeedEx = values.first.toDouble();
                                        assetsAudioPlayer
                                            .setPlaySpeed(playSpeedEx);
                                        setState(() {});
                                      },
                                      segments: const [
                                        ButtonSegment(
                                          icon: Text('1X'),
                                          value: 1.0,
                                        ),
                                        ButtonSegment(
                                          icon: Text('2X'),
                                          value: 4.0,
                                        ),
                                        ButtonSegment(
                                          icon: Text('3X'),
                                          value: 8.0,
                                        ),
                                        ButtonSegment(
                                          icon: Text('4X'),
                                          value: 16.0,
                                        ),
                                      ],
                                      selected: {
                                        playSpeedEx
                                      }),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Slider(
                            inactiveColor: Colors.amber,
                            value: valueEx.toDouble(),
                            min: 0,
                            max:
                                snapShots.data?.duration.inSeconds.toDouble() ??
                                    0.0,
                            onChanged: (value) async {
                              setState(() {
                                valueEx = value.toInt();
                              });
                            },
                            onChangeEnd: (value) async {
                              await assetsAudioPlayer
                                  .seek(Duration(seconds: value.toInt()));
                            },
                          ),
                          Text(
                            '${convertSeconds(valueEx)}  /  ${convertSeconds(snapShots.data?.duration.inSeconds ?? 0)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  String convertSeconds(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String secondsStr = (seconds % 60).toString();
    return '${minutes.padLeft(2, '0')}:${secondsStr.padLeft(2, '0')}';
  }

  Widget get getBtnWIdget =>
      assetsAudioPlayer.builderIsPlaying(builder: (ctx, isPlaying) {
        return FloatingActionButton.large(
          onPressed: () {
            if (isPlaying) {
              assetsAudioPlayer.pause();
            } else {
              assetsAudioPlayer.play();
            }
            setState(() {});
          },
          shape: const CircleBorder(),
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 70,
          ),
        );
      });
}
