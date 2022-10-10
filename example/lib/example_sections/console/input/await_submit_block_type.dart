import 'package:example/example_sections/string/string_puzzle_piece.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_console_widget/flutter_console.dart';
import 'package:programming_blocks/models/block_type.dart';

import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';

import 'package:programming_blocks/programming_blocks.dart';

class AwaitSubmitBlockModel extends ProgrammingBlockModel {
  AwaitSubmitBlockModel()
      : super(
          type: AwaitSubmitBlockType.typeName,
        );
}

class AwaitSubmitBlockType extends BlockType {
  static String typeName = 'AWAIT_SUBMIT';
  AwaitSubmitBlockType({
    required CreationSectionData sectionData,
    required this.consoleController,
  }) : super(
          sectionData: sectionData,
          shape: ProgrammingBlockShape.simple,
          name: typeName,
          puzzlePieceData: const StringPuzzlePiece(),
        );

  final FlutterConsoleController consoleController;

  @override
  Future<void> execute(ExecutionBlockController? executionController) async {
    await consoleController.scan();
  }

  @override
  Widget nameBuilder(ProgrammingBlockController? blockController) =>
      const Text('Programming Blocks');

  @override
  Widget panelBuilder(ProgrammingBlockController? blockController) =>
      const SizedBox.shrink();

  @override
  ProgrammingBlockModel? blockModel() {
    return AwaitSubmitBlockModel();
  }
}
