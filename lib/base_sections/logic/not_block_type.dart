import 'package:programming_blocks/base_sections/number/input_targets/bool_input_target.dart';
import 'package:programming_blocks/base_sections/number/number_puzzle_piece.dart';
import 'package:programming_blocks/base_sections/number/number_serializable.dart';
import 'package:flutter/widgets.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_block_controller.dart';

class NotBlockModel extends ProgrammingBlockModel {
  NotBlockModel() : super(returnType: 'NUMBER', type: NotBlockType.typeName);
}

class NotBlockType extends BlockType {
  static String typeName = 'NOT';
  NotBlockType({required CreationSectionData sectionData})
      : super(
          sectionData: sectionData,
          shape: ProgrammingBlockShape.withReturn,
          puzzlePieceData: const NumberPuzzlePiece(),
          name: typeName,
        );

  @override
  Future<void> execute(ExecutionBlockController? executionController) async {}

  @override
  Widget nameBuilder(ProgrammingBlockController? blockController) =>
      const Text('Not');

  @override
  Widget panelBuilder(ProgrammingBlockController? blockController) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BoolInputTarget(
            blockInputTargetKey: 'OPERATOR_A',
            blockColor: blockController?.blockColor,
          ),
        ],
      );

  @override
  Future<dynamic> readData(ReadBlockController? readBlockController) async {
    final readedValue = NumberSerializable.fromMap(
      await readBlockController!.readInput(
        blockInputTargetKey: 'OPERATOR_A',
      ),
    );
    return NumberSerializable.toMap(readedValue == 0 ? 1 : 0);
  }

  @override
  ProgrammingBlockModel? blockModel() {
    return NotBlockModel();
  }
}
