import 'package:flutter/material.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/models/puzzle_piece_data.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_block_controller.dart';

import '../ui/programming_blocks/controllers/execution_block_controller.dart';
import '../ui/programming_blocks/controllers/programming_block_controller.dart';

abstract class BlockType {
  const BlockType({
    required this.name,
    required this.sectionData,
    required this.shape,
    this.puzzlePieceData = const PuzzlePieceData(
      sides: 3,
      topPadding: 5.0,
      size: 16,
    ),
  });

  final CreationSectionData sectionData;
  final ProgrammingBlockShape shape;
  final String name;
  final PuzzlePieceData puzzlePieceData;

  Widget nameBuilder(ProgrammingBlockController? blockController);
  Widget panelBuilder(ProgrammingBlockController? blockController);

  Future<void> execute(ExecutionBlockController? executionController);
  Future<dynamic> readData(ReadBlockController? readBlockController) async {
    return null;
  }

  ProgrammingBlockModel? blockModel();
}

enum ProgrammingBlockShape {
  scope,
  simple,
  withReturn,
}
