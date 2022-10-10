import 'package:example/example_sections/string/string_puzzle_piece.dart';
import 'package:example/example_sections/string/string_serializable.dart';

import 'package:flutter/widgets.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/models/configuration_block_model.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_block_controller.dart';

class StringBlockModel extends ProgrammingBlockModel {
  StringBlockModel({
    required String configurationUuid,
    required String? defaultData,
    required String name,
  }) : super(
          configurationUuid: configurationUuid,
          defaultData: {'value': defaultData},
          name: name,
          type: StringBlockType.typeName,
          returnType: 'STRING',
        );
}

class StringConfigBlockModel extends ConfigurationBlockModel {
  StringConfigBlockModel({
    required Map<String, dynamic> configArguments,
    required String typeName,
    required String uuid,
    required String name,
  }) : super(
            configArguments: configArguments,
            typeName: typeName,
            uuid: uuid,
            blockName: name,
            blockModel: StringBlockModel(
              configurationUuid: uuid,
              defaultData: '',
              name: name,
            ));
}

class StringBlockType extends BlockType {
  static String typeName = 'STRING';
  StringBlockType({
    required CreationSectionData sectionData,
  }) : super(
            sectionData: sectionData,
            shape: ProgrammingBlockShape.withReturn,
            puzzlePieceData: const StringPuzzlePiece(),
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
    return StringSerializable.toMap(
        readBlockController?.configBlockModel?.configArguments['value']);
  }

  @override
  ProgrammingBlockModel? blockModel() => null;
}
