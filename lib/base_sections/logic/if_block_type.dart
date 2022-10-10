import 'package:programming_blocks/base_sections/number/input_targets/bool_input_target.dart';
import 'package:programming_blocks/base_sections/number/number_serializable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';

class IfBlockModel extends ProgrammingBlockModel {
  IfBlockModel()
      : super(
          type: IfBlockType.typeName,
        );
}

class IfBlockType extends BlockType {
  static String typeName = 'IF';
  IfBlockType({required CreationSectionData sectionData})
      : super(
          sectionData: sectionData,
          shape: ProgrammingBlockShape.scope,
          name: typeName,
        );

  @override
  Future<void> execute(ExecutionBlockController? executionController) async {
    final condition =
        NumberSerializable.fromMap(await executionController?.readInput(
      blockInputTargetKey: 'CONDITION',
    ));
    if (condition != 0) {
      for (final blockModel in executionController?.blockModel.blocks ?? []) {
        await executionController?.execute(blockModel: blockModel);
      }
    }
  }

  @override
  Widget nameBuilder(ProgrammingBlockController? blockController) =>
      const Text('If');

  @override
  Widget panelBuilder(ProgrammingBlockController? blockController) {
    return BoolInputTarget(
      blockInputTargetKey: 'CONDITION',
      blockColor: blockController?.blockColor,
    );
  }

  @override
  ProgrammingBlockModel? blockModel() => IfBlockModel();
}
