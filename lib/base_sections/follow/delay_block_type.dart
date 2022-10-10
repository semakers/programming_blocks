import 'package:programming_blocks/base_sections/number/input_targets/number_input_target.dart';
import 'package:programming_blocks/base_sections/number/number_serializable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';

class DelayBlockModel extends ProgrammingBlockModel {
  DelayBlockModel()
      : super(
          type: DelayBlockType.typeName,
        );
}

class DelayBlockType extends BlockType {
  static String typeName = 'DELAY';
  DelayBlockType({required CreationSectionData sectionData})
      : super(
          sectionData: sectionData,
          shape: ProgrammingBlockShape.simple,
          name: typeName,
        );

  @override
  Future<void> execute(ExecutionBlockController? executionController) async {
    await Future.delayed(
      Duration(
          milliseconds: NumberSerializable.fromMap(
        await executionController?.readInput(
          blockInputTargetKey: 'MILLIS',
        ),
      ).toInt()),
    );
  }

  @override
  Widget nameBuilder(ProgrammingBlockController? blockController) =>
      const Text('Delay');

  @override
  Widget panelBuilder(ProgrammingBlockController? blockController) {
    return Row(
      children: const [
        NumberInputTarget(
          blockInputTargetKey: 'MILLIS',
          defaultData: {'value': 1000},
        ),
        Text(' millis'),
      ],
    );
  }

  @override
  ProgrammingBlockModel? blockModel() => DelayBlockModel();
}
