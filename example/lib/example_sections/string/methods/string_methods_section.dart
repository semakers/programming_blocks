import 'package:example/example_sections/string/methods/compare_block_type.dart';
import 'package:example/example_sections/string/methods/length_block_type.dart';
import 'package:example/example_sections/string/methods/to_lower_type.dart';
import 'package:example/example_sections/string/methods/to_number_type.dart';
import 'package:example/example_sections/string/methods/to_upper_type.dart';
import 'package:flutter/material.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/creation_panel/section/types/simple_section.dart';

class StringMethodsSection extends _StringMethodsSection {
  StringMethodsSection({
    Key? key,
    required Color color,
  }) : super(
          key: key,
          sectionData: CreationSectionData(
            name: 'Methods',
            color: color,
          ),
        );
}

class _StringMethodsSection extends SimpleSection {
  _StringMethodsSection({
    Key? key,
    required CreationSectionData sectionData,
  }) : super(
            creationSectionData: sectionData,
            blocktypes: [
              LengthBlockType(
                sectionData: sectionData,
              ),
              CompareBlockType(
                sectionData: sectionData,
              ),
              ToNumberBlockType(
                sectionData: sectionData,
              ),
              ToLowerBlockType(
                sectionData: sectionData,
              ),
              ToUpperBlockType(
                sectionData: sectionData,
              ),
            ],
            key: key);
}
