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
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Search songs or artists",
            ),
            onChanged: (v) => setState(() => query = v),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: songsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final q = query.toLowerCase();
              final songs = snapshot.data!.where((s) =>
                  s.title.toLowerCase().contains(q) ||
                  s.artist.toLowerCase().contains(q)).toList();
              return ListView.separated(
                itemCount: songs.length,
                itemBuilder: (context, index) => SongTile(
                  song: songs[index],
                  onPressed: () => queue.value = [...queue.value, songs[index]],
                ),
                separatorBuilder: (context, index) => const Divider(height: 1),
              );
            },
          )
        ),
      ],
    );
  }
}