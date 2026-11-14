import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({super.key, this.fileName = "saved_data.json"});
  final String fileName;

  @override
  State<ExportPage> createState() => _ExportPageState();
}


class _ExportPageState extends State<ExportPage> {
  bool _exporting = false;

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${widget.fileName}');
      if (!await file.exists()) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing saved yet')),
        );
        return;
      }
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/json')],
          subject: 'Saved data',
        ),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) => IconButton(
    icon: _exporting
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Icon(Icons.share),
    tooltip: "Export Data",
    onPressed: _exporting ? null : _export,
  );
}
