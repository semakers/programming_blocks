import 'package:programming_blocks/base_sections/number/instances/number_instances_section.dart';
import 'package:programming_blocks/base_sections/number/methods/number_methods_section.dart';
import 'package:flutter/material.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/creation_panel/section/types/divided_section.dart';

class NumbersSection extends _NumbersSection {
  NumbersSection({
    Key? key,
    Color? color,
  }) : super(
          key: key,
          sectionData: CreationSectionData(
            name: 'Numbers',
            color: color ?? Colors.redAccent,
          ),
        );
}

class _NumbersSection extends DividedSection {
  _NumbersSection({
    Key? key,
    required CreationSectionData sectionData,
  }) : super(
          key: key,
          creationSectionData: sectionData,
          subSections: {
            'Instances': NumberInstancesSection(
              color: sectionData.color,
            ),
            'Methods': NumberMethodsSection(
              color: sectionData.color,
            ),
          },
        );
}
