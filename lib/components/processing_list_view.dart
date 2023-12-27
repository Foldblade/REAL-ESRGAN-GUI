import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProcessingListView extends StatefulWidget {
  const ProcessingListView({super.key, required this.processingList});
  final List<Map<String, dynamic>> processingList;

  @override
  _ProcessingListViewState createState() => _ProcessingListViewState();
}

class _ProcessingListViewState extends State<ProcessingListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.processingList.length,
        itemBuilder: (buildContext, int index) {
          return Card(
              child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: FittedBox(
                                  fit: BoxFit.fill,
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.file(
                                    File(widget.processingList[index]["input"]),
                                  )),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.processingList[index]["input"]),
                                Text(
                                    "    -> ${widget.processingList[index]["output"]}")
                              ],
                            ),
                          )
                        ],
                      ),
                      if (widget.processingList[index]["status"] < 0.0)
                        const Icon(
                          Icons.pending_actions,
                          size: 32,
                        ),
                      if (0.0 <= widget.processingList[index]["status"] &&
                          widget.processingList[index]["status"] < 1.0)
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: FittedBox(
                            child: CircularProgressIndicator(
                              value: widget.processingList[index]["status"],
                              semanticsLabel: 'Circular progress indicator',
                            ),
                          ),
                        ),
                      if (widget.processingList[index]["status"] == 1.0)
                        const Icon(
                          Icons.check_circle_outline,
                          size: 32,
                        ),
                      if (widget.processingList[index]["status"] == 2.0)
                        const Icon(
                          Icons.error_outline,
                          size: 32,
                        )
                    ],
                  )));
        });
  }
}
