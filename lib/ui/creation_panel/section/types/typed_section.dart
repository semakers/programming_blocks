import 'package:flutter/material.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/drag_and_drop/draggable_programming_block.dart';
import 'package:programming_blocks/ui/programming_blocks/block_by_shape.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/configuration_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/programming_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/programming_block.dart';

abstract class TypedSection extends CreationSection {
  const TypedSection({
    this.addInstanceButtonBuilder,
    required CreationSectionData creationSectionData,
    required this.instancesblockType,
    required this.instancesFunctionsBlockTypes,
    Key? key,
    required this.typeName,
  })  : _creationData = creationSectionData,
        super(creationSectionData: creationSectionData, key: key);

  final CreationSectionData _creationData;
  final Widget Function(BuildContext, CreationSectionData)?
      addInstanceButtonBuilder;
  final BlockType instancesblockType;
  final List<BlockType> instancesFunctionsBlockTypes;
  final String typeName;

  Future<ConfigurationBlockModel?> addInstance(BuildContext context);

  void onEditInstance(
    BuildContext context,
    ConfigurationBlockController controller,
  );

  @override
  Widget buildSection(BuildContext context) {
    ProgrammingBlocksDependency programmingBlocks =
        ProgrammingBlocksDependency.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ValueListenableBuilder<List<ConfigurationBlockModel?>>(
          valueListenable:
              programmingBlocks.panelController.configListListeneble,
          builder: (context, configurationBlockModels, _) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      final newInstance = await addInstance(context);
                      if (newInstance != null) {
                        programmingBlocks.addConfigurationBlockModel(
                            configurationBlockModel: newInstance);
                      }
                    },
                    child: addInstanceButtonBuilder != null
                        ? addInstanceButtonBuilder!(
                            context, creationSectionData)
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Add ${_creationData.name}',
                              style: TextStyle(
                                color: _creationData.color,
                              ),
                            ),
                          ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (configurationBlockModels
                          .where(
                            (element) =>
                                element?.typeName == typeName &&
                                element?.uuid !=
                                    ProgrammingBlocksDependency.mainCanvasUuid,
                          )
                          .isNotEmpty)
                        ...instancesFunctionsBlockTypes
                            .map((e) => DraggableProgrammingBlock(
                                  removeOnDrag: false,
                                  blockModel: () => e.blockModel()!,
                                  child: AbsorbPointer(
                                    child: BlockByShape.build(
                                      puzzlePieceData: e.puzzlePieceData,
                                      shape: e.shape,
                                      blockModel: null,
                                      nameBuilder: (_) => e.nameBuilder(
                                        null,
                                      ),
                                      panelBuilder: () => e.panelBuilder(
                                        null,
                                      ),
                                      color: _creationData.color,
                                      fromCreationSection: true,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ...configurationBlockModels
                          .where(
                        (element) =>
                            element?.typeName == typeName &&
                            element?.uuid !=
                                ProgrammingBlocksDependency.mainCanvasUuid,
                      )
                          .map((e) {
                        return e == null
                            ? const SizedBox.shrink()
                            : InkWell(
                                onTap: () {
                                  onEditInstance(
                                      context,
                                      ConfigurationBlockController(
                                          programmingBlocks: programmingBlocks,
                                          configurationBlockModel: e));
                                },
                                child: DraggableProgrammingBlock(
                                  removeOnDrag: false,
                                  blockModel: () => e.blockModel,
                                  child: BlockByShape.build(
                                      puzzlePieceData:
                                          instancesblockType.puzzlePieceData,
                                      shape: instancesblockType.shape,
                                      blockModel: e.blockModel,
                                      nameBuilder: (_) {
                                        return Builder(builder: (context) {
                                          final programmingBlock =
                                              ProgrammingBlock.of(context);
                                          return instancesblockType.nameBuilder(
                                            ProgrammingBlockController(
                                              programmingBlock:
                                                  programmingBlock!,
                                            ),
                                          );
                                        });
                                      },
                                      panelBuilder: () {
                                        return Builder(builder: (context) {
                                          return instancesblockType
                                              .panelBuilder(
                                                  ProgrammingBlockController(
                                                      programmingBlock:
                                                          ProgrammingBlock.of(
                                                              context)!));
                                        });
                                      },
                                      color: _creationData.color,
                                      fromCreationSection: true),
                                ),
                              );
                      }).toList(),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
