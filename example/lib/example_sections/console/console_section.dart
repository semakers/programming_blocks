import 'package:example/example_sections/console/input/input_section.dart';
import 'package:example/example_sections/console/output/output_section.dart';

import 'package:flutter/material.dart';
import 'package:flutter_console_widget/flutter_console_controller.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/creation_panel/section/types/divided_section.dart';

class ConsoleSection extends _ConsoleSection {
  ConsoleSection({
    Key? key,
    required FlutterConsoleController consoleController,
    Color? color,
  }) : super(
          key: key,
          consoleController: consoleController,
          sectionData: CreationSectionData(
            name: 'Console',
            color: color ?? Colors.pink,
          ),
        );
}

class _ConsoleSection extends DividedSection {
  _ConsoleSection({
    Key? key,
    required this.consoleController,
    required CreationSectionData sectionData,
  }) : super(
          key: key,
          creationSectionData: sectionData,
          subSections: {
            'Output': OutputSection(
              consoleController: consoleController,
              color: sectionData.color,
            ),
            'Input': InputSection(
              consoleController: consoleController,
              color: sectionData.color,
            ),
          },
        );

  final FlutterConsoleController consoleController;
}
