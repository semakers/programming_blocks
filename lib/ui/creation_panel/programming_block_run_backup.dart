import 'dart:ui';

import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/ui/block_input/block_input_target_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/programming_block.dart';

enum RunBackupType { inputTarget, scopeBlock, canvasPosition }

class ProgrammingBlockRunBackupController {
  ProgrammingBlockRunBackup? blockRunBackup;

  void restoreProgrammingBlock() {
    if (blockRunBackup != null) {
      switch (blockRunBackup!.type) {
        case RunBackupType.inputTarget:
          blockRunBackup?.inputController?.setBlock(
            newBlockModel: blockRunBackup!.backupBlockModel,
          );
          break;
        case RunBackupType.scopeBlock:
          blockRunBackup?.scopeController?.addBlockByIndex(
              index: blockRunBackup!.index,
              newBlockModel: blockRunBackup!.backupBlockModel);
          break;
        case RunBackupType.canvasPosition:
          if (blockRunBackup!.position != Offset.zero) {
            blockRunBackup?.backupBlockModel.position =
                blockRunBackup!.position;
            blockRunBackup?.canvasController.currentSingleCanvas?.newBlock =
                blockRunBackup!.backupBlockModel;
          }

          break;
      }
      blockRunBackup = null;
    }
  }
}

class ProgrammingBlockRunBackup {
  ProgrammingBlockRunBackup({
    required this.canvasController,
    required this.inputController,
    required this.scopeController,
    required this.parentProgrammingBlock,
    required this.backupBlockModel,
  })  : type = inputController != null
            ? RunBackupType.inputTarget
            : scopeController != null
                ? RunBackupType.scopeBlock
                : RunBackupType.canvasPosition,
        position = backupBlockModel.position {
    if (inputController != null) {
      index = parentProgrammingBlock?.blockModel?.inputs
              .indexOf(inputController!.inputModel) ??
          -1;
    } else if (scopeController != null) {
      index =
          scopeController?.originalModel?.blocks.indexOf(backupBlockModel) ??
              -1;
    }
  }

  final Offset position;
  final RunBackupType type;
  final ProgrammingBlock? parentProgrammingBlock;
  final BlockInputTargetController? inputController;
  final ScopeBlockController? scopeController;
  final ProgrammingBlockModel backupBlockModel;
  final CanvasController canvasController;
  late int index;
}
