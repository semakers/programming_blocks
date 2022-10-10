import 'package:programming_blocks/base_sections/logic/comparation_block_type.dart';
import 'package:programming_blocks/base_sections/logic/if_block_type.dart';
import 'package:programming_blocks/base_sections/logic/logic_block_type.dart';
import 'package:programming_blocks/base_sections/logic/not_block_type.dart';
import 'package:flutter/material.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/creation_panel/section/types/simple_section.dart';

class LogicSection extends _LogicSection {
  LogicSection({
    Key? key,
    Color? color,
  }) : super(
          key: key,
          sectionData: CreationSectionData(
            name: 'Logic',
            color: color ?? Colors.blue,
          ),
        );
}

class _LogicSection extends SimpleSection {
  _LogicSection({
    Key? key,
    required CreationSectionData sectionData,
  }) : super(
            creationSectionData: sectionData,
            blocktypes: [
              IfBlockType(
                sectionData: sectionData,
              ),
              ComparationBlockType(
                sectionData: sectionData,
              ),
              LogicBlockType(
                sectionData: sectionData,
              ),
              NotBlockType(
                sectionData: sectionData,
              ),
            ],
            key: key);
}
