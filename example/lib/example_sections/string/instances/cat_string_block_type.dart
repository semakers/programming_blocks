import 'package:example/example_sections/string/input_targets/string_input_target.dart';
import 'package:example/example_sections/string/string_serializable.dart';
import 'package:flutter/material.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';
import 'package:programming_blocks/ui/variable_selector/variable_selector.dart';

class CatStringBlockModel extends ProgrammingBlockModel {
  CatStringBlockModel()
      : super(
          type: CatStringBlockType.typeName,
        );
}

class CatStringBlockType extends BlockType {
  static String typeName = 'CAT_STRING';
  CatStringBlockType({
    required CreationSectionData sectionData,
  }) : super(
            sectionData: sectionData,
            shape: ProgrammingBlockShape.simple,
            name: typeName);

  @override
  Future<void> execute(ExecutionBlockController? executionController) async {
    final originalValue = (await executionController
        ?.readArgsOfSelectedVariable(variableType: 'STRING'))!['value'];
    await executionController?.updateSelectedVariable(
      variableType: 'STRING',
      configArguments: {
        'value': originalValue +
            StringSerializable.fromMap(
              await executionController.readInput(
                blockInputTargetKey: 'VALUE',
              ),
            )
      },
    );
  }

  @override
  Widget nameBuilder(ProgrammingBlockController? blockController) =>
      const Text('');

  @override
  Widget panelBuilder(ProgrammingBlockController? blockController) => Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Cat',
          ),
          VariableSelector(
            textColor: Colors.white,
            variableType: 'STRING',
          ),
          Text(
            'To',
          ),
          StringInputTarget(
            blockInputTargetKey: 'VALUE',
          )
        ],
      );

  @override
  ProgrammingBlockModel? blockModel() => CatStringBlockModel();
}
