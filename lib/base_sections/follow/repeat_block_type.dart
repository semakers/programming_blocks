import 'package:programming_blocks/base_sections/number/input_targets/number_input_target.dart';
import 'package:programming_blocks/base_sections/number/number_serializable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';

class RepeatBlockModel extends ProgrammingBlockModel {
  RepeatBlockModel() : super(type: RepeatBlockType.typeName);
}

class RepeatBlockType extends BlockType {
  static String typeName = 'REPEAT';
  RepeatBlockType({required CreationSectionData sectionData})
      : super(
          sectionData: sectionData,
          shape: ProgrammingBlockShape.scope,
          name: typeName,
        );

  @override
  Future<void> execute(ExecutionBlockController? executionController) async {
    final repetitions =
        NumberSerializable.fromMap(await executionController?.readInput(
      blockInputTargetKey: 'REPETITIONS',
    ))
            .toInt();
    for (int i = 0; i < repetitions; i++) {
      for (final blockModel in executionController?.blockModel.blocks ?? []) {
        await executionController?.execute(blockModel: blockModel);
      }
    }
  }

  @override
  Widget nameBuilder(ProgrammingBlockController? blockController) =>
      const Text('Repeat');

  @override
  Widget panelBuilder(ProgrammingBlockController? blockController) {
    return const NumberInputTarget(
      blockInputTargetKey: 'REPETITIONS',
      defaultData: {'value': 1},
    );
  }

  @override
  ProgrammingBlockModel? blockModel() => RepeatBlockModel();
}
