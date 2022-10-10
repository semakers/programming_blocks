import 'package:example/example_sections/console/input/await_submit_block_type.dart';
import 'package:example/example_sections/console/input/next_number_block_type.dart';
import 'package:example/example_sections/console/input/next_string_block_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_console_widget/flutter_console.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/creation_panel/section/types/simple_section.dart';

class InputSection extends _InputSection {
  InputSection({
    Key? key,
    required FlutterConsoleController consoleController,
    required Color color,
  }) : super(
          key: key,
          consoleController: consoleController,
          sectionData: CreationSectionData(
            name: 'Input',
            color: color,
          ),
        );
}

class _InputSection extends SimpleSection {
  _InputSection({
    Key? key,
    required this.consoleController,
    required CreationSectionData sectionData,
  }) : super(
            creationSectionData: sectionData,
            blocktypes: [
              NextStringBlockType(
                sectionData: sectionData,
                consoleController: consoleController,
              ),
              NextNumberBlockType(
                sectionData: sectionData,
                consoleController: consoleController,
              ),
              AwaitSubmitBlockType(
                sectionData: sectionData,
                consoleController: consoleController,
              ),
            ],
            key: key);

  final FlutterConsoleController consoleController;
}
