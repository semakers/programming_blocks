import 'package:programming_blocks/base_sections/number/input_targets/bool_input_target.dart';
import 'package:programming_blocks/base_sections/number/number_puzzle_piece.dart';
import 'package:programming_blocks/base_sections/number/number_serializable.dart';
import 'package:programming_blocks/base_sections/logic/logic_operation_selector.dart';
import 'package:flutter/widgets.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_block_controller.dart';

class LogicBlockModel extends ProgrammingBlockModel {
  LogicBlockModel()
      : super(returnType: 'NUMBER', type: LogicBlockType.typeName);
}

class LogicBlockType extends BlockType {
  static String typeName = 'LOGIC';
  LogicBlockType({required CreationSectionData sectionData})
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
          BoolInputTarget(
            blockInputTargetKey: 'OPERATOR_A',
            blockColor: blockController?.blockColor,
          ),
          LogicOperationSelector(),
          BoolInputTarget(
            blockInputTargetKey: 'OPERATOR_B',
            blockColor: blockController?.blockColor,
          ),
        ],
      );

  @override
  Future readData(ReadBlockController? readBlockController) async {
    final double a = NumberSerializable.fromMap(await readBlockController!
        .readInput(blockInputTargetKey: 'OPERATOR_A'));
    final double b = NumberSerializable.fromMap(
        await readBlockController.readInput(blockInputTargetKey: 'OPERATOR_B'));

    final String logicOperation = await readBlockController.readSelector(
        dataSelectorKey: 'LOGIC_OPERATOR');
    double _value = 0;
    if (logicOperation == LogicOperation.and.toString()) {
      _value = (a != 0 && b != 0) ? 1 : 0;
    } else if (logicOperation == LogicOperation.or.toString()) {
      _value = (a != 0 || b != 0) ? 1 : 0;
    }
    return NumberSerializable.toMap(_value);
  }

  @override
  ProgrammingBlockModel? blockModel() {
    return LogicBlockModel();
  }
}
