import 'package:example/example_sections/string/string_puzzle_piece.dart';
import 'package:example/example_sections/string/string_serializable.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_console_widget/flutter_console.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_block_controller.dart';

class NextStringBlockModel extends ProgrammingBlockModel {
  NextStringBlockModel()
      : super(
          returnType: 'STRING',
          type: NextStringBlockType.typeName,
        );
}

class NextStringBlockType extends BlockType {
  static String typeName = 'NEXT_STRING';
  NextStringBlockType({
    required CreationSectionData sectionData,
    required this.consoleController,
  }) : super(
          sectionData: sectionData,
          shape: ProgrammingBlockShape.withReturn,
          name: typeName,
          puzzlePieceData: const StringPuzzlePiece(),
        );

  final FlutterConsoleController consoleController;

  @override
  Future<void> execute(ExecutionBlockController? executionController) async {}

  @override
  Widget nameBuilder(ProgrammingBlockController? blockController) =>
      const Text('Next string');

  @override
  Widget panelBuilder(ProgrammingBlockController? blockController) =>
      const SizedBox.shrink();

  @override
  Future readData(ReadBlockController? readBlockController) async {
    consoleController.focusNode.requestFocus();
    final value = await consoleController.scan();
    consoleController.print(
      message: value,
      endline: true,
    );
    return StringSerializable.toMap(value);
  }

  @override
  ProgrammingBlockModel? blockModel() {
    return NextStringBlockModel();
  }
}
