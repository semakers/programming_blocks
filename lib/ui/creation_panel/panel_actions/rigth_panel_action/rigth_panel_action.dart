import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/creation_panel/panel_actions/creation_panel_action.dart';
import 'package:programming_blocks/ui/creation_panel/panel_actions/rigth_panel_action/areas/puzzle_button.dart';
import 'package:programming_blocks/ui/creation_panel/panel_actions/rigth_panel_action/areas/trash_area.dart';

class RigthPanelAction extends StatelessWidget {
  const RigthPanelAction({
    Key? key,
    required this.animationNotifier,
    required this.trashBuilder,
    required this.openCloseBuilder,
  }) : super(key: key);

  final ValueNotifier<double> animationNotifier;
  final Widget Function(bool)? trashBuilder;
  final Widget Function()? openCloseBuilder;

  @override
  Widget build(BuildContext context) {
    final panelController =
        ProgrammingBlocksDependency.of(context)!.panelController;
    return CreationPanelAction(
      align: CreationPanelActionAlignment.rigth,
      animationNotifier: animationNotifier,
      child: ValueListenableBuilder<RunningState>(
          valueListenable: panelController.runningStateListenable,
          builder: (context, runningState, _) {
            return runningState == RunningState.running
                ? const SizedBox.shrink()
                : ValueListenableBuilder<bool>(
                    valueListenable: panelController.draggingBlockListenable,
                    builder: (context, draggingBlock, _) {
                      return draggingBlock
                          ? TrashArea(
                              trashBuilder: trashBuilder,
                            )
                          : PuzzleButton(
                              openCloseBuilder: openCloseBuilder,
                            );
                    });
          }),
    );
  }
}
