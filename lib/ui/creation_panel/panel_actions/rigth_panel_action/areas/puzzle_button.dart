import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';

class PuzzleButton extends StatelessWidget {
  const PuzzleButton({
    Key? key,
    required this.openCloseBuilder,
  }) : super(key: key);

  final Widget Function()? openCloseBuilder;

  @override
  Widget build(BuildContext context) {
    final panelController =
        ProgrammingBlocksDependency.of(context)!.panelController;
    return InkWell(
        onTap: () {
          if (panelController.isOpen) {
            panelController.close();
          } else {
            panelController.open();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: openCloseBuilder?.call() ??
              const Icon(
                Icons.extension,
                size: 50.0,
              ),
        ));
  }
}
