import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/drag_and_drop/draggable_programming_block.dart';
import 'package:programming_blocks/ui/drag_and_drop/programming_block_drag_target.dart';

class ScopeBlock extends StatelessWidget {
  const ScopeBlock({
    Key? key,
    this.blockModel,
    required this.nameBuilder,
    required this.panelBuilder,
    required this.color,
    required this.fromCreationSection,
  }) : super(key: key);

  final ProgrammingBlockModel? blockModel;
  final Widget Function(ProgrammingBlockModel? blockModel) nameBuilder;
  final Widget Function() panelBuilder;
  final Color color;
  final bool fromCreationSection;

  @override
  Widget build(BuildContext context) {
    return ScopeBlockController(
      blockModel: blockModel,
      nameBuilder: nameBuilder,
      panelBuilder: panelBuilder,
      color: color,
      fromCreationSection: fromCreationSection,
      parentScopeBlock: ScopeBlockController.of(context),
    );
  }
}

class ScopeBlockController extends InheritedWidget {
  ScopeBlockController({
    Key? key,
    required ProgrammingBlockModel? blockModel,
    required Widget Function(ProgrammingBlockModel? blockModel) nameBuilder,
    required Widget Function() panelBuilder,
    required Color color,
    required bool fromCreationSection,
    required ScopeBlockController? parentScopeBlock,
  })  : _blockModel = blockModel,
        originalModel = blockModel,
        blocksNotifier = ValueNotifier(blockModel?.blocks ?? []),
        dividerNotifier = ValueNotifier(null),
        super(
            key: key,
            child: _ScopeBlockBody(
              blockModel: blockModel,
              nameBuilder: nameBuilder,
              panelBuilder: panelBuilder,
              color: color,
              fromCreationSection: fromCreationSection,
              parentScopeBlock: parentScopeBlock,
            ));

  final ProgrammingBlockModel? _blockModel;
  final ProgrammingBlockModel? originalModel;

  final ValueNotifier<List<ProgrammingBlockModel>> blocksNotifier;
  final ValueNotifier<ProgrammingBlockModel?> dividerNotifier;

  void removeBlock({
    required ProgrammingBlockModel blockModel,
  }) {
    _blockModel!.blocks.remove(blockModel);
    blocksNotifier.value =
        _blockModel!.blocks.where((element) => true).toList();
  }

  void addBlock({
    required ProgrammingBlockModel targetBlockModel,
    required ProgrammingBlockModel newBlockModel,
  }) {
    _blockModel!.blocks.insert(
        _blockModel!.blocks.indexOf(targetBlockModel) + 1, newBlockModel);
    blocksNotifier.value =
        _blockModel!.blocks.where((element) => true).toList();
    hideDivider();
  }

  void addBlockByIndex({
    required int index,
    required ProgrammingBlockModel newBlockModel,
  }) {
    _blockModel!.blocks.insert(index, newBlockModel);
    blocksNotifier.value =
        _blockModel!.blocks.where((element) => true).toList();
    hideDivider();
  }

  void showDivider({
    required ProgrammingBlockModel blockModel,
  }) {
    dividerNotifier.value = blockModel;
  }

  void hideDivider() {
    dividerNotifier.value = null;
  }

  static ScopeBlockController? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ScopeBlockController>());
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class _ScopeBlockBody extends StatelessWidget {
  const _ScopeBlockBody({
    Key? key,
    required this.blockModel,
    required this.nameBuilder,
    required this.panelBuilder,
    required this.color,
    required this.fromCreationSection,
    required this.parentScopeBlock,
  }) : super(key: key);

  final ProgrammingBlockModel? blockModel;
  final Widget Function(ProgrammingBlockModel? blockModel) nameBuilder;
  final Widget Function() panelBuilder;
  final Color color;
  final bool fromCreationSection;
  final ScopeBlockController? parentScopeBlock;

  Widget topDragTarget({
    required BuildContext context,
    required Widget child,
    required ValueNotifier<bool> placeNotifier,
    required ValueNotifier<List<ProgrammingBlockModel>> blocksNotifier,
  }) {
    return BlockDragTarget(
      onBlockDroped: (dropedBlock) {
        if (dropedBlock.returnType == null) {
          blockModel?.blocks.insert(0, dropedBlock);
          placeNotifier.value = false;
          blocksNotifier.value =
              blockModel?.blocks.where((element) => true).toList() ?? [];
        } else {
          ProgrammingBlocksDependency.of(context)!
              .canvasController
              .currentSingleCanvas!
              .newBlock = dropedBlock;
        }
        return true;
      },
      onBlockEnter: (blockModel) {
        ScopeBlockController.of(context)?.hideDivider();
        if (blockModel.returnType == null) {
          placeNotifier.value = true;
        }
      },
      onBlockExit: (blockModel) {
        placeNotifier.value = false;
      },
      child: child,
    );
  }

  Widget bottomDragTarget({
    required BuildContext context,
    required Widget child,
    required ValueNotifier<bool> placeNotifier,
    required ValueNotifier<List<ProgrammingBlockModel>> blocksNotifier,
  }) {
    return BlockDragTarget(
      onBlockDroped: (dropedBlock) {
        if (dropedBlock.returnType == null) {
          blockModel?.blocks.add(dropedBlock);
          placeNotifier.value = false;
          blocksNotifier.value =
              blockModel?.blocks.where((element) => true).toList() ?? [];
        } else {
          ProgrammingBlocksDependency.of(context)!
              .canvasController
              .currentSingleCanvas!
              .newBlock = dropedBlock;
        }
        return true;
      },
      onBlockEnter: (blockModel) {
        ScopeBlockController.of(context)?.hideDivider();
        if (blockModel.returnType == null) {
          placeNotifier.value = true;
        }
      },
      onBlockExit: (blockModel) {
        placeNotifier.value = false;
      },
      child: child,
    );
  }

  Widget nestedBottomDragTarget({
    required Widget child,
    required BuildContext context,
  }) {
    return BlockDragTarget(
      onBlockDroped: (dropedBlock) {
        if (dropedBlock.returnType == null) {
          parentScopeBlock!.addBlock(
            targetBlockModel: blockModel!,
            newBlockModel: dropedBlock,
          );
        } else {
          ProgrammingBlocksDependency.of(context)!
              .canvasController
              .currentSingleCanvas!
              .newBlock = dropedBlock;
        }
        return true;
      },
      onBlockEnter: (enterBlockModel) {
        if (enterBlockModel.returnType == null) {
          parentScopeBlock!.showDivider(
            blockModel: blockModel!,
          );
        }
      },
      onBlockExit: (blockModel) {
        parentScopeBlock!.hideDivider();
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> firstPlaceNotifier = ValueNotifier(false);
    final ValueNotifier<bool> lastPlaceNotifier = ValueNotifier(false);
    final blocksNotifier = ScopeBlockController.of(context)!.blocksNotifier;

    final leftBorderDecoration = ShapeDecoration(
      shape: Border(
        left: BorderSide(width: 12, color: color),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fromCreationSection
            ? SimpleBlock(
                blockModel: blockModel,
                headerOfScopeBlock: true,
                nameBuilder: nameBuilder,
                panelBuilder: panelBuilder,
                color: color,
              )
            : topDragTarget(
                context: context,
                blocksNotifier: blocksNotifier,
                placeNotifier: firstPlaceNotifier,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SimpleBlock(
                      blockModel: blockModel,
                      headerOfScopeBlock: true,
                      nameBuilder: nameBuilder,
                      panelBuilder: panelBuilder,
                      color: color,
                    ),
                    Container(
                      decoration: leftBorderDecoration,
                      child: ValueListenableBuilder<bool>(
                          valueListenable: firstPlaceNotifier,
                          builder: (_, enable, __) {
                            return enable
                                ? const SizedBox(
                                    height: 15,
                                  )
                                : const SizedBox.shrink();
                          }),
                    )
                  ],
                ),
              ),
        Container(
          constraints: const BoxConstraints(minHeight: 2),
          decoration: leftBorderDecoration,
          child: ValueListenableBuilder<List<ProgrammingBlockModel>>(
              valueListenable: blocksNotifier,
              builder: (_, blocks, __) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: blocks
                      .map((e) => Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DraggableProgrammingBlock(
                                removeOnDrag: true,
                                blockModel: () => e,
                                child: ProgrammingBlocksDependency.of(context)!
                                    .buildBlockByModel(
                                  context,
                                  blockModel: e,
                                  fromCreationSection: false,
                                ),
                              ),
                              ValueListenableBuilder<ProgrammingBlockModel?>(
                                  valueListenable:
                                      ScopeBlockController.of(context)!
                                          .dividerNotifier,
                                  builder: (_, blockModel, __) {
                                    return SizedBox(
                                      height: e == blockModel ? 15 : 0,
                                    );
                                  })
                            ],
                          ))
                      .toList(),
                );
              }),
        ),
        fromCreationSection
            ? _Footer(color: color)
            : parentScopeBlock != null
                ? nestedBottomDragTarget(
                    context: context,
                    child: _Footer(color: color),
                  )
                : bottomDragTarget(
                    context: context,
                    blocksNotifier: blocksNotifier,
                    placeNotifier: lastPlaceNotifier,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: leftBorderDecoration,
                          child: ValueListenableBuilder<bool>(
                              valueListenable: lastPlaceNotifier,
                              builder: (_, enable, __) {
                                return enable
                                    ? const SizedBox(
                                        height: 15,
                                      )
                                    : const SizedBox.shrink();
                              }),
                        ),
                        _Footer(
                          color: color,
                        ),
                      ],
                    ),
                  )
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 70.0,
        height: 13.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(4.0),
            bottomRight: Radius.circular(8.0),
          ),
        ));
  }
}
