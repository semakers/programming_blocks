import 'package:example/example_sections/string/input_targets/string_input_target.dart';
import 'package:example/example_sections/string/string_serializable.dart';
import 'package:programming_blocks/base_sections/number/number_puzzle_piece.dart';

import 'package:flutter/widgets.dart';
import 'package:programming_blocks/base_sections/number/number_serializable.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_block_controller.dart';

class CompareBlockModel extends ProgrammingBlockModel {
  CompareBlockModel()
      : super(returnType: 'NUMBER', type: CompareBlockType.typeName);
}

class CompareBlockType extends BlockType {
  static String typeName = 'COMPARE';
  CompareBlockType({required CreationSectionData sectionData})
      : super(
          sectionData: sectionData,
          shape: ProgrammingBlockShape.withReturn,
          name: typeName,
          puzzlePieceData: const NumberPuzzlePiece(),
        );

  @override
  Future<void> execute(ExecutionBlockController? executionController) async {}

  @override
  Widget nameBuilder(ProgrammingBlockController? blockController) =>
      const SizedBox.shrink();

  @override
  Widget panelBuilder(ProgrammingBlockController? blockController) => Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('Compare'),
          StringInputTarget(
            blockInputTargetKey: 'OPERATOR_A',
          ),
          Text('with'),
          StringInputTarget(
            blockInputTargetKey: 'OPERATOR_B',
          ),
        ],
      );

  @override
  Future readData(ReadBlockController? readBlockController) async {
    final String a = StringSerializable.fromMap(await readBlockController!
        .readInput(blockInputTargetKey: 'OPERATOR_A'));
    final String b = StringSerializable.fromMap(
        await readBlockController.readInput(blockInputTargetKey: 'OPERATOR_B'));
    return NumberSerializable.toMap(a.compareTo(b).toDouble());
  }

  @override
  ProgrammingBlockModel? blockModel() {
    return CompareBlockModel();
  }
}
