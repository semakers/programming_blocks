import 'package:example/example_sections/string/input_targets/string_input_target.dart';
import 'package:example/example_sections/string/string_serializable.dart';

import 'package:flutter/material.dart';
import 'package:flutter_console_widget/flutter_console.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/models/programming_block_model.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';

class PrintStringBlockModel extends ProgrammingBlockModel {
  PrintStringBlockModel()
      : super(type: PrintStringBlockType.typeName, panelArguments: {
          'end_line': true,
        });
}

class PrintStringBlockType extends BlockType {
  static String typeName = 'PRINT_STRING';
  PrintStringBlockType({
    required CreationSectionData sectionData,
    required this.consoleController,
  }) : super(
          sectionData: sectionData,
          shape: ProgrammingBlockShape.simple,
          name: typeName,
        );

  final FlutterConsoleController consoleController;

  @override
  Future<void> execute(ExecutionBlockController? executionController) async {
    final readedValue =
        StringSerializable.fromMap(await executionController?.readInput(
      blockInputTargetKey: 'VALUE',
    ));
    consoleController.print(
      message: readedValue,
      endline:
          executionController?.blockModel.panelArguments['end_line'] == true,
    );
  }

  @override
  Widget nameBuilder(ProgrammingBlockController? blockController) =>
      const Text('print');

  @override
  Widget panelBuilder(ProgrammingBlockController? blockController) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StringInputTarget(
            blockInputTargetKey: 'VALUE',
          ),
          Checkbox(
              value: blockController?.blockModel.panelArguments['end_line'] ??
                  true,
              onChanged: (value) {
                blockController?.blockModel.panelArguments['end_line'] = value;
                blockController?.refreshPanel();
              }),
          const Text('end line'),
        ],
      );

  @override
  ProgrammingBlockModel? blockModel() {
    return PrintStringBlockModel();
  }
}
