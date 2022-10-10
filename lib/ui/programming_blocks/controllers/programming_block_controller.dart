import 'package:flutter/material.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/programming_blocks/programming_block.dart';

class ProgrammingBlockController {
  ProgrammingBlockController({
    required ProgrammingBlock programmingBlock,
  }) : _programmingBlock = programmingBlock;

  final ProgrammingBlock _programmingBlock;

  ProgrammingBlockModel get blockModel => _programmingBlock.blockModel!;

  Color get blockColor => _programmingBlock.color;

  void refreshPanel() {
    _programmingBlock.refreshPanel();
  }
}
