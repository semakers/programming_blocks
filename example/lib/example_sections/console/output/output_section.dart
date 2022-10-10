import 'package:example/example_sections/console/output/print_number_block_type.dart';
import 'package:example/example_sections/console/output/print_string_block_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_console_widget/flutter_console.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/creation_panel/section/types/simple_section.dart';

class OutputSection extends _OutputSection {
  OutputSection({
    Key? key,
    required FlutterConsoleController consoleController,
    required Color color,
  }) : super(
          key: key,
          consoleController: consoleController,
          sectionData: CreationSectionData(
            name: 'Output',
            color: color,
          ),
        );
}

class _OutputSection extends SimpleSection {
  _OutputSection({
    Key? key,
    required this.consoleController,
    required CreationSectionData sectionData,
  }) : super(
            creationSectionData: sectionData,
            blocktypes: [
              PrintNumberBlockType(
                sectionData: sectionData,
                consoleController: consoleController,
              ),
              PrintStringBlockType(
                sectionData: sectionData,
                consoleController: consoleController,
              ),
            ],
            key: key);

  final FlutterConsoleController consoleController;
}
