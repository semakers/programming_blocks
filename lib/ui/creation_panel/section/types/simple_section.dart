import 'package:flutter/material.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/drag_and_drop/draggable_programming_block.dart';
import 'package:programming_blocks/ui/programming_blocks/block_by_shape.dart';

abstract class SimpleSection extends CreationSection {
  const SimpleSection({
    this.addInstanceButtonBuilder,
    required CreationSectionData creationSectionData,
    required this.blocktypes,
    Key? key,
  })  : _creationData = creationSectionData,
        super(
          creationSectionData: creationSectionData,
          key: key,
        );

  final CreationSectionData _creationData;
  final Widget Function(CreationSectionData)? addInstanceButtonBuilder;
  final List<BlockType> blocktypes;

  @override
  Widget buildSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...blocktypes
                  .map((e) => DraggableProgrammingBlock(
                        removeOnDrag: false,
                        blockModel: () => e.blockModel()!,
                        child: AbsorbPointer(
                          child: BlockByShape.build(
                              puzzlePieceData: e.puzzlePieceData,
                              shape: e.shape,
                              blockModel: null,
                              nameBuilder: (_) => e.nameBuilder(null),
                              panelBuilder: () => e.panelBuilder(
                                    null,
                                  ),
                              color: _creationData.color,
                              fromCreationSection: true),
                        ),
                      ))
                  .toList(),
            ],
          ),
        );
      }),
    );
  }
}
