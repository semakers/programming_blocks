import 'package:programming_blocks/base_sections/number/number_puzzle_piece.dart';
import 'package:programming_blocks/base_sections/number/number_serializable.dart';
import 'package:flutter/widgets.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_block_controller.dart';

class NumberBlockModel extends ProgrammingBlockModel {
  NumberBlockModel({
    required String configurationUuid,
    required double? defaultData,
    required String name,
  }) : super(
          configurationUuid: configurationUuid,
          defaultData: {'value': defaultData},
          name: name,
          type: NumberBlockType.typeName,
          returnType: 'NUMBER',
        );
}

class NumberConfigBlockModel extends ConfigurationBlockModel {
  NumberConfigBlockModel({
    required Map<String, dynamic> configArguments,
    required String typeName,
    required String uuid,
    required String name,
  }) : super(
            configArguments: configArguments,
            typeName: typeName,
            uuid: uuid,
            blockName: name,
            blockModel: NumberBlockModel(
              configurationUuid: uuid,
              defaultData: 0,
              name: name,
            ));
}

class NumberBlockType extends BlockType {
  static String typeName = 'NUMBER';
  NumberBlockType({
    required CreationSectionData sectionData,
  }) : super(
            sectionData: sectionData,
            shape: ProgrammingBlockShape.withReturn,
            puzzlePieceData: const NumberPuzzlePiece(),
            name: typeName);

  @override
  Future<void> execute(ExecutionBlockController? executionController) async {}

  @override
  Widget nameBuilder(ProgrammingBlockController? blockController) =>
      Text(blockController?.blockModel.name ?? '');

  @override
  Widget panelBuilder(ProgrammingBlockController? blockController) =>
      const SizedBox.shrink();

  @override
  Future readData(ReadBlockController? readBlockController) async {
    return NumberSerializable.toMap(
        readBlockController?.configBlockModel?.configArguments['value']);
  }

  @override
  ProgrammingBlockModel? blockModel() => null;
}
