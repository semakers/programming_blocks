import 'dart:async';
import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/creation_panel/programming_block_run_backup.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/ui/block_input/block_input_target_controller.dart';
import 'package:programming_blocks/ui/drag_and_drop/drag_target.dart' as dt;
import 'package:programming_blocks/ui/programming_blocks/programming_block.dart';

class DraggableProgrammingBlock extends InheritedWidget {
  DraggableProgrammingBlock({
    Key? key,
    VoidCallback? onDragCompleted,
    required ProgrammingBlockModel? Function() blockModel,
    required Widget child,
    VoidCallback? onDragStarted,
    required bool removeOnDrag,
  }) : super(
          child: _BodyDraggableProgrammingBlock(
            child: child,
            blockModel: blockModel,
            removeOnDrag: removeOnDrag,
            onDragStarted: onDragStarted,
            onDragCompleted: onDragCompleted,
          ),
          key: key,
        );

  final ValueNotifier<Size> headerSizeNotifier = ValueNotifier(Size.zero);

  static DraggableProgrammingBlock? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DraggableProgrammingBlock>();
  }

  @override
  bool updateShouldNotify(DraggableProgrammingBlock oldWidget) {
    return true;
  }
}

class _BodyDraggableProgrammingBlock extends StatelessWidget {
  const _BodyDraggableProgrammingBlock({
    Key? key,
    required this.child,
    required this.blockModel,
    required this.removeOnDrag,
    this.onDragCompleted,
    this.onDragStarted,
  }) : super(key: key);

  final VoidCallback? onDragCompleted;
  final ProgrammingBlockModel? Function() blockModel;
  final Widget child;
  final VoidCallback? onDragStarted;
  final bool removeOnDrag;

  @override
  Widget build(BuildContext context) {
    final programmingBlocks = ProgrammingBlocksDependency.of(context)!;
    ValueNotifier<Offset> feedbackNotifier = ValueNotifier(Offset.zero);
    return Listener(
      onPointerDown: (event) async {
        feedbackNotifier.value = event.localPosition;
      },
      child: ValueListenableBuilder<Size>(
          valueListenable:
              DraggableProgrammingBlock.of(context)!.headerSizeNotifier,
          builder: (context, headerSize, _) {
            return ValueListenableBuilder<Offset>(
                valueListenable: feedbackNotifier,
                builder: (_, feedbackOffset, __) {
                  return dt.LongPressDraggable(
                    feedbackOffsets: [
                      Offset.zero,
                      -feedbackOffset,
                      //TODO
                      /*if (headerSize != Size.zero) ...[
                        Offset(-feedbackOffset.dx,
                            headerSize.height - feedbackOffset.dy)
                      ]*/
                    ],
                    delay: Duration(milliseconds: programmingBlocks.dragDelay),
                    child: child,
                    childWhenDragging:
                        removeOnDrag ? const SizedBox.shrink() : null,
                    data: blockModel(),
                    feedback: Opacity(
                      opacity: 0.5,
                      child: Material(
                        color: Colors.transparent,
                        child: ProgrammingBlocksDependency(
                          projectModel: programmingBlocks.projectModel,
                          sections: programmingBlocks.sections,
                          injectorChild: Builder(
                            builder: (
                              context,
                            ) {
                              return child;
                            },
                          ),
                        ),
                      ),
                    ),
                    onDragCompleted: () async {
                      programmingBlocks.panelController.blockDroped();
                      programmingBlocks.canvasController.blocksBuffer
                          ?.complete(blockModel());

                      if (onDragCompleted != null) {
                        onDragCompleted!();
                      }
                      if (removeOnDrag) {
                        programmingBlocks.removeBlock(
                          context,
                          blockModel: blockModel(),
                        );
                      }
                    },
                    onDragStarted: () async {
                      if (onDragStarted != null) {
                        onDragStarted!();
                      }

                      final programmingBlock = ProgrammingBlock.of(context);
                      final inputController =
                          BlockInputTargetController.of(context);
                      final scopeController = ScopeBlockController.of(context);
                      programmingBlocks.runBackupController.blockRunBackup =
                          ProgrammingBlockRunBackup(
                        canvasController: programmingBlocks.canvasController,
                        inputController: inputController,
                        scopeController: scopeController,
                        parentProgrammingBlock: programmingBlock,
                        backupBlockModel: blockModel()!,
                      );
                      programmingBlocks.panelController.close();
                      programmingBlocks.panelController.draggingBlock();
                      programmingBlocks.canvasController.blocksBuffer =
                          Completer<ProgrammingBlockModel>();
                      programmingBlocks.paySound('disconnect.mp3');
                    },
                  );
                });
          }),
    );
  }
}
