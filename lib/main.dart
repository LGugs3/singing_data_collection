import 'package:flutter/material.dart';
import 'package:singing_data_collection/pages/export_reactions.dart';
import 'package:singing_data_collection/pages/record_data_page.dart';
import 'package:singing_data_collection/pages/sessions_page.dart';
import 'package:singing_data_collection/pages/songs_page.dart';
import 'package:singing_data_collection/reusable_widgets/song_widget.dart';

void main() {
  runApp(const MyApp());
}

final queue = ValueNotifier<List<Song>>([]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collect Singing Data',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Data Collection Home Page'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;

  @override
  bool get wantKeepAlive => true;

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    RecordDataPage(),
    SessionPage(),
    ExportPage(),
    SongsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.contact_page), label: 'Record Data'),
          NavigationDestination(icon: Icon(Icons.queue_music), label: 'Session'),
          NavigationDestination(icon: Icon(Icons.file_upload_outlined), label: 'Export'),
          NavigationDestination(icon: Icon(Icons.library_music_outlined), label: 'Search'),
        ],
      ),
    );
  }
}
