import 'package:programming_blocks/base_sections/number/input_targets/number_input_target.dart';
import 'package:programming_blocks/base_sections/number/number_puzzle_piece.dart';
import 'package:programming_blocks/base_sections/number/number_serializable.dart';
import 'package:programming_blocks/base_sections/logic/comparation_operation_selector.dart';

import 'package:flutter/widgets.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_block_controller.dart';

class ComparationBlockModel extends ProgrammingBlockModel {
  ComparationBlockModel()
      : super(returnType: 'NUMBER', type: ComparationBlockType.typeName);
}

class ComparationBlockType extends BlockType {
  static String typeName = 'COMPARATION';
  ComparationBlockType({required CreationSectionData sectionData})
      : super(
            sectionData: sectionData,
            shape: ProgrammingBlockShape.withReturn,
            puzzlePieceData: const NumberPuzzlePiece(),
            name: typeName);

  @override
  Future<void> execute(ExecutionBlockController? executionController) async {}

  @override
  Widget nameBuilder(ProgrammingBlockController? blockController) =>
      const SizedBox.shrink();

  @override
  Widget panelBuilder(ProgrammingBlockController? blockController) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const NumberInputTarget(
            blockInputTargetKey: 'OPERATOR_A',
          ),
          ComparationOperationSelector(),
          const NumberInputTarget(
            blockInputTargetKey: 'OPERATOR_B',
          ),
        ],
      );

  @override
  Future readData(ReadBlockController? readBlockController) async {
    final double a = NumberSerializable.fromMap(await readBlockController!
        .readInput(blockInputTargetKey: 'OPERATOR_A'));
    final double b = NumberSerializable.fromMap(
        await readBlockController.readInput(blockInputTargetKey: 'OPERATOR_B'));
    final String comparationOperation = await readBlockController.readSelector(
        dataSelectorKey: 'COMPARATION_OPERATOR');
    double _value = 0;
    if (comparationOperation == ComparationOperation.min.toString()) {
      _value = a < b ? 1 : 0;
    } else if (comparationOperation ==
        ComparationOperation.minEqual.toString()) {
      _value = a <= b ? 1 : 0;
    } else if (comparationOperation == ComparationOperation.equal.toString()) {
      _value = a == b ? 1 : 0;
    } else if (comparationOperation ==
        ComparationOperation.diferent.toString()) {
      _value = a != b ? 1 : 0;
    } else if (comparationOperation == ComparationOperation.max.toString()) {
      _value = a > b ? 1 : 0;
    } else if (comparationOperation ==
        ComparationOperation.maxEqual.toString()) {
      _value = a >= b ? 1 : 0;
    }
    return NumberSerializable.toMap(_value);
  }

  @override
  ProgrammingBlockModel? blockModel() {
    return ComparationBlockModel();
  }
}
