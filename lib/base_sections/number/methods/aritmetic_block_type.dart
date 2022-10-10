import 'package:programming_blocks/base_sections/number/input_targets/number_input_target.dart';
import 'package:programming_blocks/base_sections/number/number_puzzle_piece.dart';
import 'package:programming_blocks/base_sections/number/number_serializable.dart';
import 'package:programming_blocks/base_sections/number/methods/aritmetic_operation_selector.dart';
import 'package:flutter/widgets.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_block_controller.dart';

class AritmeticBlockModel extends ProgrammingBlockModel {
  AritmeticBlockModel()
      : super(returnType: 'NUMBER', type: AritmeticBlockType.typeName);
}

class AritmeticBlockType extends BlockType {
  static String typeName = 'ARITMETIC';
  AritmeticBlockType({required CreationSectionData sectionData})
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
        children: [
          const NumberInputTarget(
            blockInputTargetKey: 'OPERATOR_A',
          ),
          AritmeticOperationSelector(),
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
    final String aritmeticOperation = await readBlockController.readSelector(
        dataSelectorKey: 'ARITMETIC_OPERATOR');
    double _value = 0;
    if (aritmeticOperation == AritmeticOperation.add.toString()) {
      _value = a + b;
    } else if (aritmeticOperation == AritmeticOperation.sub.toString()) {
      _value = a - b;
    } else if (aritmeticOperation == AritmeticOperation.mul.toString()) {
      _value = a * b;
    } else if (aritmeticOperation == AritmeticOperation.div.toString()) {
      _value = a / b;
    } else if (aritmeticOperation == AritmeticOperation.mod.toString()) {
      _value = a % b;
    }
    return NumberSerializable.toMap(_value);
  }

  @override
  ProgrammingBlockModel? blockModel() {
    return AritmeticBlockModel();
  }
}
