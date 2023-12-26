import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DropdownArea extends StatefulWidget {
  const DropdownArea({Key? key, required this.child, this.droppedFiles})
      : super(key: key);
  final Widget child;
  final Future<void> Function(List<XFile> files)? droppedFiles;

  @override
  _DropdownAreaState createState() => _DropdownAreaState();
}

class _DropdownAreaState extends State<DropdownArea> {
  final List<XFile> _list = [];

  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) {
        setState(() {
          _list.addAll(detail.files);
          widget.droppedFiles?.call(detail.files);
        });
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
        });
      },
      child: widget.child,
    );
  }
}
