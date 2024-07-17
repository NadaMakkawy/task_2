import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:task_2/widgets/song_widget.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist playlist;

  const PlaylistPage({
    required this.playlist,
    super.key,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Playlist'),
      ),
      body: ListView(
        children: [
          for (var song in widget.playlist.audios)
            SongWidget(
              audio: song,
            ),
        ],
      ),
    );
  }
}
