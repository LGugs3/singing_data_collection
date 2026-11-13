import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Song {
  static int _nextId = 0;

  final int id;
  final String title;
  final String artist;
  final double duration;

  Song(this.title, this.artist, this.duration) : id = _nextId++;
  Song.fromJson(Map<String, dynamic> json)
      : id = _nextId++,
        title = json['title'],
        artist = json['artist'],
        duration = (json['duration'] as num).toDouble();

  static Future<List<Song>> load() async {
    final text = await rootBundle.loadString('assets/songs.json');
    final List data = jsonDecode(text);
    return data.map((e) => Song.fromJson(e)).toList();
  }
}

class SongTile extends StatelessWidget {
  final Song song;
  final IconData icon;
  final VoidCallback onPressed;

  const SongTile({super.key, required this.song, this.icon = Icons.add, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(song.title),
      subtitle: Text("Artist: ${song.artist}\nDuration: ${song.duration.toStringAsFixed(2)} minutes"),
      trailing: IconButton(onPressed: onPressed, icon: Icon(icon)),
    );
  }
}