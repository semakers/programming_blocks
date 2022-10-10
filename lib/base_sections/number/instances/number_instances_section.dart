import 'package:programming_blocks/base_sections/number/dialogs/add_number_dialog.dart';
import 'package:programming_blocks/base_sections/number/dialogs/modify_number_dialog.dart';
import 'package:programming_blocks/base_sections/number/instances/number_block_type.dart';
import 'package:programming_blocks/base_sections/number/instances/set_number_block_type.dart';
import 'package:flutter/material.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/creation_panel/section/types/typed_section.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/configuration_block_controller.dart';

class NumberInstancesSection extends _NumberInstancesSection {
  NumberInstancesSection({
    Key? key,
    required Color color,
  }) : super(
          key: key,
          sectionData: CreationSectionData(
            name: 'Number',
            color: color,
          ),
        );
}

class _NumberInstancesSection extends TypedSection {
  _NumberInstancesSection({
    Key? key,
    required CreationSectionData sectionData,
  }) : super(
            creationSectionData: sectionData,
            instancesblockType: NumberBlockType(
              sectionData: sectionData,
            ),
            instancesFunctionsBlockTypes: [
              SetNumberBlockType(sectionData: sectionData)
            ],
            typeName: NumberBlockType.typeName,
            key: key);

  @override
  Future<NumberConfigBlockModel?> addInstance(BuildContext context) async {
    return AddNumberDialog().show(
      context,
    );
  }

  @override
  void onEditInstance(
      BuildContext context, ConfigurationBlockController controller) async {
    final modified = await ModifyNumberDialog(
      numberConfigBlockModel: controller.configurationBlockModel,
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
