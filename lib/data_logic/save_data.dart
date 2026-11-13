import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

enum Places {
  aiken,
  finney,
}

List<DropdownMenuEntry<Places>> placesDropdownBuilder() {
  return List<DropdownMenuEntry<Places>>.generate(
    Places.values.length,
    (index) => DropdownMenuEntry(value: Places.values[index], label: Places.values[index].name),
  );
}

enum Reactions {
  positive,
  negative,
  neutral
}

List<DropdownMenuEntry<Reactions>> reactionsDropdownBuilder() {
  return List<DropdownMenuEntry<Reactions>>.generate(
    Reactions.values.length,
      (index) => DropdownMenuEntry(value: Reactions.values[index], label: Reactions.values[index].name),
  );
}

class ResponseData {
  final String song;
  final DateTime time;
  final Places place;
  final Reactions reaction;

  // constructors
  const ResponseData(this.song, this.time, this.place, this.reaction);
  ResponseData.now(this.song, this.place, this.reaction) :
      time = DateTime.now();
  ResponseData.fromJson(Map<String, dynamic> json) :
      song = json['song'],
      time = DateTime.parse(json['time'] as String),
      place = Places.values.byName(json['place']),
      reaction = Reactions.values.byName(json['reaction']);

  // serialize
  Map<String, dynamic> toJson() => {
    'song': song,
    'time': time.toIso8601String(),
    'place': place.name,
    'reaction': reaction.name,
  };
}

// get data json file
Future<File> _file() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/saved_data.json');
}

// parse json in file
Future<List<ResponseData>> readSaved() async {
  final file = await _file();
  if (!await file.exists()) return [];
  final List data = jsonDecode(await file.readAsString());
  return data.map((e) => ResponseData.fromJson(e)).toList();
}

//append new record to json and save
Future<void> saveResponse(ResponseData data) async {
  final responses = await readSaved();
  responses.add(data);
  final file = await _file();

  await file.writeAsString(jsonEncode(responses.map((r) => r.toJson()).toList()));
}