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
  final List<String> _supportedModels = [
    "realesr-animevideov3",
    "realesrgan-x4plus",
    "realesrgan-x4plus-anime",
    "realesrnet-x4plus"
  ];
  final List<int> _supportedUpscaleRatio = [2, 3, 4];

  final TextEditingController _modelSelectionController =
      TextEditingController();
  final TextEditingController _upscaleRatioSelectionController =
      TextEditingController();

  @override
  void initState() {
    for (var filePath in widget.filePaths) {
      _processingList.add({
        "input": filePath,
        "output": "",
        "status": -1.0,
      });
    }
    super.initState();
  }

  Future<void> processOneImage(int index) async {
    setState(() {
      _processingList[index]["status"] = 0.0;
      _processingList[index]["output"] =
          "${p.withoutExtension(_processingList[index]["input"])}_${_upscaleRatioSelectionController.text}x_${_modelSelectionController.text}${p.extension(_processingList[index]["input"])}";
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
        '-s',
        _upscaleRatioSelectionController.text,
        '-n',
        _modelSelectionController.text,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownMenu(
                          initialSelection: _supportedModels[0],
                          controller: _modelSelectionController,
                          label: const Text('Model'),
                          // onSelected: (String? modelName) {},
                          dropdownMenuEntries:
                              _supportedModels.map((modelName) {
                            return DropdownMenuEntry<String>(
                              value: modelName,
                              label: modelName,
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        DropdownMenu(
                          initialSelection:
                              _supportedUpscaleRatio[2].toString(),
                          controller: _upscaleRatioSelectionController,
                          label: const Text('Upscale Ratio'),
                          // onSelected: (upscaleRatio) {},
                          dropdownMenuEntries:
                              _supportedUpscaleRatio.map((upscaleRatio) {
                            return DropdownMenuEntry<String>(
                              value: upscaleRatio.toString(),
                              label: upscaleRatio.toString(),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    OutlinedButton(
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
                        child: SizedBox(
                            height: 56,
                            child: Center(child: Text("Start".toUpperCase())))),
                  ],
                ),
              ),
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
