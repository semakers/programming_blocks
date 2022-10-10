import 'package:flutter/material.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/block_input/block_input_target_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/programming_block.dart';
import 'package:programming_blocks/ui/drag_and_drop/drag_target.dart' as dt;

class BlockDragTarget extends StatelessWidget {
  const BlockDragTarget({
    Key? key,
    required this.child,
    required this.onBlockDroped,
    required this.onBlockEnter,
    required this.onBlockExit,
  }) : super(key: key);
  final Widget child;

  final bool Function(ProgrammingBlockModel blockModel) onBlockDroped;
  final Function(ProgrammingBlockModel blockmodel)? onBlockEnter;
  final Function(ProgrammingBlockModel blockModel)? onBlockExit;

  @override
  Widget build(BuildContext context) {
    final programmingBlocks = ProgrammingBlocksDependency.of(context)!;
    final blockModel = ProgrammingBlock.of(context)?.blockModel;
    final inputTarget = BlockInputTargetController.of(context);
    return dt.DragTarget(
      builder: (BuildContext context, List<Object?> candidateData,
          List<dynamic> rejectedData) {
        return child;
      },
      onWillAccept: (data) {
        final enterBlockModel = (data as ProgrammingBlockModel);

        final enterBlockType =
            programmingBlocks.typeByBlockModel(blockModel: enterBlockModel);

        if (onBlockEnter != null) {
          onBlockEnter!(enterBlockModel);
        }

        if (enterBlockType?.shape != ProgrammingBlockShape.withReturn &&
            inputTarget != null) {
          return false;
        }

        return !(blockModel == enterBlockModel);
      },
      onLeave: (data) {
        if (onBlockExit != null) {
          onBlockExit!(data as ProgrammingBlockModel);
        }
      },
      onAcceptWithDetails: (data) async {
        final canvasController = programmingBlocks.canvasController;

        canvasController.blocksBuffer?.future.then(
          (blockModel) {
            final offset = canvasController.fixedPosition(
              data.offset,
            );
            final size = programmingBlocks
                .canvasController.currentSingleCanvas!.canvasModel.size;
            if (offset.dx > 0 &&
                offset.dy > 0 &&
                offset.dx < size.width &&
                offset.dy < size.height) {
              blockModel.position = offset;
            }
            final playClick = onBlockDroped(blockModel);
            if (playClick) {
              programmingBlocks.paySound('click.mp3');
            }
            programmingBlocks.onProjectChange?.call(
              programmingBlocks.projectModel,
            );
          },
        );
      },
    );
  }
}
