import 'package:flutter/material.dart';
import 'package:singing_data_collection/data_logic/save_data.dart';
import 'package:singing_data_collection/reusable_widgets/song_widget.dart';

import '../main.dart';

class RecordDataPage extends StatefulWidget {
  const RecordDataPage({super.key});


  @override
  State<RecordDataPage> createState() => _RecordDataPageState();
}

class _RecordDataPageState extends State<RecordDataPage> {

  Song? currentSong;
  Reactions observedReaction = Reactions.neutral;
  Places currentPlace = Places.finney;

  void submitRecord() {
    final newRecord = ResponseData.now(queue.value.first.title, currentPlace, observedReaction);
    saveResponse(newRecord);
  }

  void _onQueueChanged() => setState(() {
    if (queue.value.isNotEmpty) {
      currentSong = queue.value.first;
    }
  });

  // ValueListenableBuilder<List<Song>> getCurrentSong() {
  //   return ValueListenableBuilder<List<Song>>(
  //     valueListenable: queue,
  //     builder: (context, items, _) {
  //       if (items.isEmpty) {
  //         return Text("No song playing");
  //       }
  //       return Text(items.first.title);
  //     }
  //   );
  // }

  @override
  void initState() {
    super.initState();
    queue.addListener(_onQueueChanged);
  }

  @override
  void dispose() {
    queue.removeListener(_onQueueChanged);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 20,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(currentSong?.title ?? "No song playing"),
            DropdownMenu(
              label: const Text("Location"),
              enableSearch: false,
              onSelected: (Places? value) => currentPlace = value ?? Places.finney,
              dropdownMenuEntries: placesDropdownBuilder(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownMenu(
              label: const Text("Reaction"),
              enableSearch: false,
              onSelected: (Reactions? value) => observedReaction = value ?? Reactions.neutral,
              dropdownMenuEntries: reactionsDropdownBuilder(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              label: const Text("Submit"),
              onPressed: submitRecord,
              icon: Icon(Icons.send),
            ),
          ],
        )
      ],
    );
  }
}