import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../components/dropdown_area.dart';
import '../pages/processing.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void pushToProcess(List<String> filePaths) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProcessingPage(filePaths: filePaths)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("REAL ESRGAN GUI"),
      ),
      body: DropdownArea(
        droppedFiles: (files) async {
          pushToProcess(files.map((file) => file.path).toList());
        },
        child: InkWell(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform
                .pickFiles(allowMultiple: true, type: FileType.image);

            if (result != null) {
              // List<File> filePaths =
              //     result.paths.map((path) => File(path!)).toList();
              pushToProcess(result.paths.map((path) => path!).toList());
            } else {
              // User canceled the picker
            }
          },
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add_circle_outline, size: 128),
                Text("Select or Drop images here"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
