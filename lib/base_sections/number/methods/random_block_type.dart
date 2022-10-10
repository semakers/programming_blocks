import 'dart:math';

import 'package:programming_blocks/base_sections/number/input_targets/number_input_target.dart';
import 'package:programming_blocks/base_sections/number/number_puzzle_piece.dart';
import 'package:programming_blocks/base_sections/number/number_serializable.dart';
import 'package:flutter/widgets.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_block_controller.dart';

class RandomBlockModel extends ProgrammingBlockModel {
  RandomBlockModel()
      : super(returnType: 'NUMBER', type: RandomBlockType.typeName);
}

class RandomBlockType extends BlockType {
  static String typeName = 'RANDOM';
  RandomBlockType({required CreationSectionData sectionData})
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
          Text('Random from'),
          NumberInputTarget(
            blockInputTargetKey: 'OPERATOR_A',
          ),
          Text('to'),
          NumberInputTarget(
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
    return NumberSerializable.toMap(
      (Random().nextInt(b.toInt() - a.toInt() + 1) + a.toInt()).toDouble(),
    );
  }

  @override
  ProgrammingBlockModel? blockModel() {
    return RandomBlockModel();
  }
}
