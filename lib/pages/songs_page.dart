import 'package:flutter/material.dart';
import 'package:singing_data_collection/reusable_widgets/song_widget.dart';

import '../main.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}


class _SongsPageState extends State<SongsPage> {

  final songsFuture = Song.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: songsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final songs = snapshot.data!;
        return ListView.separated(
          itemCount: songs.length,
          itemBuilder: (context, index) => SongTile(
            song: songs[index],
            onPressed: () => queue.value = [...queue.value, songs[index]],
          ),
          separatorBuilder: (context, index) => const Divider(height: 1),
        );
      },
    );
  }
}