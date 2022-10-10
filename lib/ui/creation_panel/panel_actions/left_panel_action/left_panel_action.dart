import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/creation_panel/panel_actions/creation_panel_action.dart';
import 'package:programming_blocks/ui/creation_panel/panel_actions/left_panel_action/areas/run_area.dart';
import 'package:programming_blocks/ui/creation_panel/panel_actions/left_panel_action/areas/stop_area.dart';

class LeftPanelAction extends StatelessWidget {
  const LeftPanelAction({
    Key? key,
    required this.animationNotifier,
    required this.runBuilder,
    required this.stopBuilder,
  }) : super(key: key);

  final ValueNotifier<double> animationNotifier;
  final Widget Function(Color? enterBlockColor)? runBuilder;
  final Widget Function()? stopBuilder;

  @override
  Widget build(BuildContext context) {
    final programmingBlocks = ProgrammingBlocksDependency.of(context)!;
    final panelController = programmingBlocks.panelController;
    return CreationPanelAction(
      align: CreationPanelActionAlignment.left,
      animationNotifier: animationNotifier,
      child: ValueListenableBuilder<bool>(
          valueListenable: panelController.draggingBlockListenable,
          builder: (context, draggingBlock, _) {
            return draggingBlock || programmingBlocks.drawMainScope
                ? ValueListenableBuilder<RunningState>(
                    valueListenable: programmingBlocks
                        .panelController.runningStateListenable,
                    builder: (context, runningState, _) {
                      return runningState == RunningState.stoped
                          ? RunArea(
                              runBuilder: runBuilder,
                            )
                          : StopArea(
                              stopBuilder: stopBuilder,
                            );
                    })
                : const SizedBox.shrink();
          }),
    );
  }
}
