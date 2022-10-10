import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/drag_and_drop/programming_block_drag_target.dart';

class RunArea extends StatelessWidget {
  const RunArea({
    Key? key,
    required this.runBuilder,
  }) : super(key: key);

  final Widget Function(Color? enterBlockColor)? runBuilder;

  void setRunningState(
      {required ValueNotifier<RunningState> runningListenable,
      required ProgrammingBlocksDependency programmingBlocks,
      required RunningState runningState}) {
    runningListenable.value = runningState;
    programmingBlocks.onChangeRunningState?.call(
      runningState,
    );
  }

  @override
  Widget build(BuildContext context) {
    final programmingBlocks = ProgrammingBlocksDependency.of(context)!;
    final runningListenable =
        programmingBlocks.panelController.runningStateListenable;
    final ValueNotifier<bool> onBlockEnterListeneable =
        ValueNotifier<bool>(false);
    Color? enterBlockColor;

    return BlockDragTarget(
      onBlockDroped: (blockModel) {
        enterBlockColor = null;
        onBlockEnterListeneable.value = false;
        programmingBlocks.restoreRunBackUp();
        setRunningState(
          runningListenable: runningListenable,
          programmingBlocks: programmingBlocks,
          runningState: RunningState.running,
        );

        programmingBlocks.panelController.runningOperation =
            CancelableOperation.fromFuture(
          programmingBlocks.executeBlock(
            blockModel: blockModel,
          ),
          onCancel: () {
            setRunningState(
              runningListenable: runningListenable,
              programmingBlocks: programmingBlocks,
              runningState: RunningState.stoped,
            );
          },
        );

        programmingBlocks.panelController.runningOperation!.value.then((value) {
          setRunningState(
            runningListenable: runningListenable,
            programmingBlocks: programmingBlocks,
            runningState: RunningState.stoped,
          );
        });

        programmingBlocks.panelController.runningOperation!.value
            .whenComplete(() {
          setRunningState(
            runningListenable: runningListenable,
            programmingBlocks: programmingBlocks,
            runningState: RunningState.stoped,
          );
        });
        return true;
      },
      onBlockEnter: (blockModel) {
        enterBlockColor = programmingBlocks.colorByBlockModel(
          blockModel: blockModel,
        );
        onBlockEnterListeneable.value = true;
      },
      onBlockExit: (blockModel) {
        enterBlockColor = null;
        onBlockEnterListeneable.value = false;
      },
      child: ValueListenableBuilder<bool>(
          valueListenable: onBlockEnterListeneable,
          builder: (context, onBlockEnter, _) {
            final Widget result = Padding(
              padding: const EdgeInsets.all(8.0),
              child: runBuilder != null
                  ? runBuilder!(enterBlockColor)
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    50.0,
                                  ),
                                  boxShadow: onBlockEnter
                                      ? const [
                                          Offset(-2, 2),
                                          Offset(2, 2),
                                          Offset(-2, -2),
                                          Offset(2, -2)
                                        ]
                                          .map((e) => BoxShadow(
                                                blurRadius: 5,
                                                offset: e,
                                                color: enterBlockColor ??
                                                    Colors.transparent,
                                              ))
                                          .toList()
                                      : null),
                              child: const SizedBox(
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.play_circle,
                          size: 50.0,
                          color: Colors.green,
                        ),
                      ],
                    ),
            );

            return programmingBlocks.drawMainScope == true
                ? InkWell(
                    onTap: () async {
                      programmingBlocks.panelController.close();
                      setRunningState(
                        runningListenable: runningListenable,
                        programmingBlocks: programmingBlocks,
                        runningState: RunningState.running,
                      );
                      programmingBlocks.panelController.runningOperation =
                          CancelableOperation.fromFuture(
                        programmingBlocks.executeBlock(
                          blockModel: programmingBlocks.canvasController
                              .blockModelByFunctionUuid(
                            functionUuid:
                                ProgrammingBlocksDependency.mainCanvasUuid,
                          )!,
                        ),
                        onCancel: () {
                          setRunningState(
                            runningListenable: runningListenable,
                            programmingBlocks: programmingBlocks,
                            runningState: RunningState.stoped,
                          );
                        },
                      );

                      programmingBlocks.panelController.runningOperation!.value
                          .then((value) {
                        setRunningState(
                          runningListenable: runningListenable,
                          programmingBlocks: programmingBlocks,
                          runningState: RunningState.stoped,
                        );
                      });

                      programmingBlocks.panelController.runningOperation!.value
                          .whenComplete(() {
                        setRunningState(
                          runningListenable: runningListenable,
                          programmingBlocks: programmingBlocks,
                          runningState: RunningState.stoped,
                        );
                      });
                    },
                    child: result,
                  )
                : result;
          }),
    );
  }
}
