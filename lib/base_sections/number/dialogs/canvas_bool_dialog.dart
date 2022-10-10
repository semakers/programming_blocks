import 'dart:async';

import 'package:flutter/material.dart';

class CanvasBoolDialog extends StatelessWidget {
  CanvasBoolDialog({
    Key? key,
    required this.blockColor,
    required this.defaultValue,
  }) : super(key: key);

  final String? defaultValue;
  final Color blockColor;

  final Completer<double?> mondifyOnCanvasCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    bool value = double.parse(defaultValue ?? '0') == 0 ? false : true;
    return AlertDialog(
      title: const Text('Set value'),
      content: Row(
        children: ['true', 'false']
            .map((e) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: e == 'true' ? 8.0 : 0.0),
                    child: InkWell(
                      onTap: () {
                        mondifyOnCanvasCompleter.complete(e == 'true' ? 1 : 0);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color:
                              (e == 'true' && value) || (e == 'false' && !value)
                                  ? blockColor
                                  : Colors.grey,
                        ),
                        height: 50,
                        child: Center(
                            child: Text(
                          e,
                          style: TextStyle(
                            color: (e == 'true' && value) ||
                                    (e == 'false' && !value)
                                ? Colors.white
                                : Colors.black,
                          ),
                        )),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Future<double?> showModifyOnCanvas(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => this,
    );
    if (!mondifyOnCanvasCompleter.isCompleted) {
      mondifyOnCanvasCompleter.complete(null);
    }
    return mondifyOnCanvasCompleter.future;
  }
}
