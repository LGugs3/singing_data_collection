import 'package:flutter/material.dart';
import 'package:singing_data_collection/reusable_widgets/song_widget.dart';

import '../main.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {

  bool expandedQueue = false;


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Song>>(
      valueListenable: queue,
      builder: (context, items, _) {
        final count = expandedQueue || items.length < 5 ? items.length : 5;
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: count,
                itemBuilder: (context, i) => SongTile(
                  song: items[i], icon: Icons.delete,
                  onPressed: () => queue.value = [...queue.value]..removeAt(i),
                )
              ),
            ),
            if (items.length > 5)
              TextButton(
                onPressed: () => setState(() => expandedQueue = !expandedQueue),
                child: Text(expandedQueue ? 'Show less' : 'Show all (${items.length})'),
              ),
          ],
        );
      },
    );
  }
}