import 'package:example/example_sections/string/dialogs/add_string_dialog.dart';
import 'package:example/example_sections/string/dialogs/modify_string_dialog.dart';
import 'package:example/example_sections/string/instances/cat_string_block_type.dart';
import 'package:example/example_sections/string/instances/set_string_block_type.dart';
import 'package:example/example_sections/string/instances/string_block_type.dart';

import 'package:flutter/material.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/creation_panel/section/types/typed_section.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/configuration_block_controller.dart';

class StringInstancesSection extends _StringInstancesSection {
  StringInstancesSection({
    Key? key,
    required Color color,
  }) : super(
          key: key,
          sectionData: CreationSectionData(
            name: 'String',
            color: color,
          ),
        );
}

class _StringInstancesSection extends TypedSection {
  _StringInstancesSection({
    Key? key,
    required CreationSectionData sectionData,
  }) : super(
            creationSectionData: sectionData,
            instancesblockType: StringBlockType(
              sectionData: sectionData,
            ),
            instancesFunctionsBlockTypes: [
              SetStringBlockType(
                sectionData: sectionData,
              ),
              CatStringBlockType(
                sectionData: sectionData,
              )
            ],
            typeName: StringBlockType.typeName,
            key: key);

  @override
  Future<StringConfigBlockModel?> addInstance(BuildContext context) async {
    return AddStringDialog().show(
      context,
    );
  }

  @override
  void onEditInstance(
      BuildContext context, ConfigurationBlockController controller) async {
    final modified = await ModifyStringDialog(
      stringConfigBlockModel: controller.configurationBlockModel,
      onRemove: () {
        controller.removeInstance();
      },
    ).show(
      context,
    );
    controller.updateInstance(
      configurationBlockModel: modified,
    );
  }
}
