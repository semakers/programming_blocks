import 'package:flutter/material.dart';
import 'package:programming_blocks/function_section/add_modify_function_dialog.dart';
import 'package:programming_blocks/function_section/function_block_type.dart';
import 'package:programming_blocks/function_section/function_config_blockmodel.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/creation_panel/section/types/typed_section.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/configuration_block_controller.dart';

import '../ui/add_modify_dialog/add_modify_dialog.dart';

class FunctionsSection extends _FunctionsSection {
  FunctionsSection({
    Key? key,
    Color? color,
  }) : super(
            key: key,
            sectionData: CreationSectionData(
              name: 'Functions',
              color: color ??
                  const Color(
                    0xFFE65100,
                  ),
            ));
}

class _FunctionsSection extends TypedSection {
  _FunctionsSection({
    Key? key,
    required CreationSectionData sectionData,
  }) : super(
            creationSectionData: sectionData,
            instancesblockType: FunctionBlockType(
              sectionData: sectionData,
            ),
            instancesFunctionsBlockTypes: const [],
            typeName: FunctionBlockType.typeName,
            key: key);

  @override
  Future<FunctionConfigBlockModel?> addInstance(BuildContext context) async {
    final functionConfigBlockModel = await AddModifyFunctionDialog(
      defaultFunctionSize:
          ProgrammingBlocksDependency.of(context)!.defaultFuntionSize,
    ).showAddModify(
      context,
      dialogType: DialogType.add,
    );

    if (functionConfigBlockModel != null) {
      final programmingBlocks = ProgrammingBlocksDependency.of(context)!;
      programmingBlocks.projectModel.functionsCanvas.add(
        functionConfigBlockModel.toCanvasModel,
      );

      programmingBlocks.canvasController.functionsListListenable.value = [
        ...programmingBlocks.projectModel.functionsCanvas
            .where((element) => true)
            .toList()
      ];

      return functionConfigBlockModel;
    }
    return null;
  }

  @override
  void onEditInstance(
      BuildContext context, ConfigurationBlockController controller) async {
    final modified = await AddModifyFunctionDialog(
      functionConfigBlockModel: controller.configurationBlockModel,
      defaultFunctionSize:
          ProgrammingBlocksDependency.of(context)!.defaultFuntionSize,
      onRemove: () {
        controller.removeInstance();
        ProgrammingBlocksDependency.of(context)!.removeFunction(
            functionUuid: controller
                .configurationBlockModel.configArguments['function_uuid']);
      },
    ).showAddModify(
      context,
      dialogType: DialogType.modify,
    );
    if (modified != null) {
      controller.updateInstance(configurationBlockModel: modified);
      ProgrammingBlocksDependency.of(context)!.updateFunctionInfo(
        functionUuid:
            controller.configurationBlockModel.configArguments['function_uuid'],
        canvasModel: modified.toCanvasModel,
      );
    }
  }
}
