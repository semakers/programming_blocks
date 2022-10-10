import 'package:programming_blocks/base_sections/number/methods/aritmetic_block_type.dart';
import 'package:programming_blocks/base_sections/number/methods/map_block_type.dart';
import 'package:programming_blocks/base_sections/number/methods/random_block_type.dart';

import 'package:flutter/material.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/creation_panel/section/types/simple_section.dart';

class NumberMethodsSection extends _NumberMethodsSection {
  NumberMethodsSection({
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

class _NumberMethodsSection extends SimpleSection {
  _NumberMethodsSection({
    Key? key,
    required CreationSectionData sectionData,
  }) : super(
            creationSectionData: sectionData,
            blocktypes: [
              AritmeticBlockType(
                sectionData: sectionData,
              ),
              RandomBlockType(
                sectionData: sectionData,
              ),
              MapBlockType(
                sectionData: sectionData,
              ),
            ],
            key: key);
}
