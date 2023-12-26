import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../components/processing_list_view.dart';

class ProcessingPage extends StatefulWidget {
  const ProcessingPage({super.key, required this.filePaths});
  final List<String> filePaths;

  @override
  State<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  List<Map<String, dynamic>> _processingList = [];
  String _title = "Selected Images";

  @override
  void initState() {
    for (var filePath in widget.filePaths) {
      _processingList.add({
        "input": filePath,
        "output":
            "${p.withoutExtension(widget.filePaths[0])}_4x${p.extension(widget.filePaths[0])}",
        "status": -1.0,
      });
    }
    super.initState();
  }

  Future<void> processOneImage(int index) async {
    setState(() {
      _processingList[index]["status"] = 0.0;
    });
    print(Directory.current.path);
    var process = await Process.start(
      p.join(Directory.current.path, 'bin',
          'realesrgan-ncnn-vulkan'), // 组个绝对路径，相对路径愚蠢的 Flutter 认不出来，，，
      [
        '-i',
        _processingList[index]["input"],
        '-o',
        _processingList[index]["output"],
      ],
      // environment: {p.join(Directory.current.path, 'bin')},
      // workingDirectory: p.join(Directory.current.path, 'bin'),
    );
    var exitCode = await process.exitCode;
    if (exitCode == 0) {
      setState(() {
        _processingList[index]["status"] = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      _title = "Processing...";
                    });
                    for (int i = 0; i < _processingList.length; i++) {
                      await processOneImage(i);
                    }
                    setState(() {
                      _title = "Done";
                    });
                  },
                  child: Text("Start".toUpperCase())),
            ),
            Expanded(
              child: ProcessingListView(processingList: _processingList),
            ),
          ],
        ),
      ),
    );
  }
}
