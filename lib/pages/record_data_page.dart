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

  Future<void> submitRecord() async {
    final newRecord = ResponseData.now(queue.value.first.title, currentPlace, observedReaction);
    await saveResponse(newRecord);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Record of ${newRecord.songTitle} with ${newRecord.reaction.name} reaction has been saved successfully."),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onQueueChanged() => setState(() {
    if (queue.value.isNotEmpty) {
      currentSong = queue.value.first;
    }
  });


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
            currentSong != null
              ? Expanded(
                child: SongTile(
                  song: currentSong!,
                  icon: Icons.skip_next,
                  onPressed: () => queue.value = [...queue.value]..removeAt(0),
                )
              )
              : Text("No Song playing"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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