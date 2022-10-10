import 'package:example/example_sections/string/input_targets/string_input_target.dart';
import 'package:example/example_sections/string/string_serializable.dart';
import 'package:programming_blocks/base_sections/number/number_puzzle_piece.dart';
import 'package:programming_blocks/base_sections/number/number_serializable.dart';
import 'package:flutter/widgets.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_block_controller.dart';

class LengthBlockModel extends ProgrammingBlockModel {
  LengthBlockModel()
      : super(returnType: 'NUMBER', type: LengthBlockType.typeName);
}

class LengthBlockType extends BlockType {
  static String typeName = 'LENGTH';
  LengthBlockType({required CreationSectionData sectionData})
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
          Text('Length'),
          StringInputTarget(
            blockInputTargetKey: 'VALUE',
          ),
        ],
      );

  @override
  Future readData(ReadBlockController? readBlockController) async {
    final String value = StringSerializable.fromMap(
        await readBlockController!.readInput(blockInputTargetKey: 'VALUE'));
    return NumberSerializable.toMap(value.length.roundToDouble());
  }

  @override
  ProgrammingBlockModel? blockModel() {
    return LengthBlockModel();
  }
}
