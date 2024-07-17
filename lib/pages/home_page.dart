import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../widgets/player_widget.dart';
import 'playlist_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  final playlistEx = Playlist(
    audios: [
      Audio(
        'assets/1.mp3',
        metas: Metas(
          title: 'Guitar',
          artist: 'Guitar Artist',
        ),
      ),
      Audio(
        'assets/2.mp3',
        metas: Metas(
          title: 'Piano',
          artist: 'Piano Artist',
        ),
      ),
      Audio(
        'assets/3.mp3',
        metas: Metas(
          title: 'Flute',
          artist: 'Flute Artist',
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistPage(
                    playlist: playlistEx,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.playlist_add_check_circle_sharp,
              color: Colors.amber,
            ),
          ),
        ],
      ),
      body: PlayerWidget(
        playlist: playlistEx,
      ),
    );
  }
}
