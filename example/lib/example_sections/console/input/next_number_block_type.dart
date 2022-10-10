import 'package:flutter_console_widget/flutter_console.dart';
import 'package:programming_blocks/base_sections/number/number_puzzle_piece.dart';
import 'package:programming_blocks/base_sections/number/number_serializable.dart';
import 'package:flutter/widgets.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_block_controller.dart';

class NextNumberBlockModel extends ProgrammingBlockModel {
  NextNumberBlockModel()
      : super(
          returnType: 'NUMBER',
          type: NextNumberBlockType.typeName,
        );
}

class NextNumberBlockType extends BlockType {
  static String typeName = 'NEXT_NUMBER';
  NextNumberBlockType({
    required CreationSectionData sectionData,
    required this.consoleController,
  }) : super(
          sectionData: sectionData,
          shape: ProgrammingBlockShape.withReturn,
          name: typeName,
          puzzlePieceData: const NumberPuzzlePiece(),
        );

  final FlutterConsoleController consoleController;

  @override
  Future<void> execute(ExecutionBlockController? executionController) async {}

  @override
  Widget nameBuilder(ProgrammingBlockController? blockController) =>
      const Text('Next number');

  @override
  Widget panelBuilder(ProgrammingBlockController? blockController) =>
      const SizedBox.shrink();

  @override
  Future readData(ReadBlockController? readBlockController) async {
    consoleController.focusNode.requestFocus();
    final value = await consoleController.scan(
      keyboardType: TextInputType.number,
    );
    consoleController.print(
      message: value,
      endline: false,
    );
    return NumberSerializable.toMap(double.tryParse(value) ?? -1);
  }

  @override
  ProgrammingBlockModel? blockModel() {
    return NextNumberBlockModel();
  }
}
