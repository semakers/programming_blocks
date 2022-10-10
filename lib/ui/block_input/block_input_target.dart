import 'package:flutter/material.dart';
import 'package:programming_blocks/models/puzzle_piece_data.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/block_input/block_input_target_controller.dart';
import 'package:programming_blocks/ui/puzzle_piece/puzzle_in.dart';
import 'package:programming_blocks/ui/drag_and_drop/draggable_programming_block.dart';
import 'package:programming_blocks/ui/drag_and_drop/programming_block_drag_target.dart';
import 'package:programming_blocks/ui/programming_blocks/programming_block.dart';
import 'package:programming_blocks/ui/puzzle_piece/puzzle_sadow.dart';

abstract class BlockInputTarget extends StatelessWidget {
  const BlockInputTarget({
    Key? key,
    required this.blockInputTargetKey,
    required this.acceptedType,
    required this.defaultData,
    required this.puzzlePieceData,
  }) : super(key: key);

  final String blockInputTargetKey;
  final String acceptedType;
  final Map<String, dynamic>? defaultData;
  final PuzzlePieceData puzzlePieceData;

  Widget valueOverview(Map<String, dynamic>? value);

  Future<void> onValueOverviewTap(BuildContext context,
      Map<String, dynamic>? value, BlockInputTargetController controller);

  void redraw(BuildContext context) {
    SingleCanvas.of(context)!.update();
  }

  @override
  Widget build(BuildContext context) {
    final programmingBlock = ProgrammingBlock.of(context)!;
    var input = programmingBlock.getBlockInput(key: blockInputTargetKey);

    if (input == null) {
      input = ProgrammingBlockInputModel(
        defaultData: defaultData,
        key: blockInputTargetKey,
        programmingBlock: null,
      );
      programmingBlock.updateBlockInput(
        blockInput: input,
      );
    }

    return BlockInputTargetController(
      inputModel: input,
      child: _Body(
        puzzlePieceData: puzzlePieceData,
        blockInputTargetKey: blockInputTargetKey,
        acceptedType: acceptedType,
        valueOverview: valueOverview,
        onValueOverviewTap: onValueOverviewTap,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(
      {Key? key,
      required this.blockInputTargetKey,
      required this.acceptedType,
      required this.valueOverview,
      required this.onValueOverviewTap,
      required this.puzzlePieceData})
      : super(key: key);

  final String blockInputTargetKey;
  final PuzzlePieceData puzzlePieceData;
  final String acceptedType;
  final Widget Function(Map<String, dynamic>? value) valueOverview;
  final Function(BuildContext context, Map<String, dynamic>? value,
      BlockInputTargetController controller) onValueOverviewTap;

  @override
  Widget build(BuildContext context) {
    final programmingBlock = ProgrammingBlock.of(context)!;
    final programmingBlocks = ProgrammingBlocksDependency.of(context)!;
    final inputController = BlockInputTargetController.of(context)!;

    ValueNotifier<Color?> enterBlockColorNotifier = ValueNotifier(
      null,
    );

    var input = programmingBlock.getBlockInput(
      key: blockInputTargetKey,
    );

    if (input != null) {
      inputController.programmingBlockNotifier.value = input.programmingBlock;
    } else {
      input = ProgrammingBlockInputModel(
        defaultData: null,
        key: blockInputTargetKey,
        programmingBlock: null,
      );
      programmingBlock.updateBlockInput(
        blockInput: input,
      );
    }

    if (input.programmingBlock != null) {
      inputController.showEmptyNotifier.value = false;
    }

    return DefaultTextStyle(
      style: const TextStyle(color: Colors.black),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: BlockDragTarget(
          onBlockDroped: (blockModel) {
            if (blockModel.returnType == acceptedType) {
              if (inputController.programmingBlockNotifier.value != null &&
                  inputController.programmingBlockNotifier.value !=
                      blockModel) {
                inputController.programmingBlockNotifier.value?.position =
                    programmingBlock.blockModel!.position +
                        const Offset(30.0, 30.0);

                programmingBlocks
                        .canvasController.currentSingleCanvas?.newBlock =
                    inputController.programmingBlockNotifier.value!;
              }

              BlockInputTargetController.of(context)!
                  .setBlock(newBlockModel: blockModel);
            } else {
              programmingBlocks.canvasController.currentSingleCanvas!.newBlock =
                  blockModel;
            }

            enterBlockColorNotifier.value = null;
            return true;
          },
          onBlockEnter: (blockModel) {
            if (blockModel.returnType == acceptedType) {
              Color enterColor =
                  programmingBlocks.colorByBlockModel(blockModel: blockModel);

              enterBlockColorNotifier.value =
                  enterColor == programmingBlock.color
                      ? Colors.grey
                      : enterColor;
            }
          },
          onBlockExit: (_) {
            enterBlockColorNotifier.value = null;
          },
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PuzzleIn(
                    puzzlePieceData: puzzlePieceData,
                  ),
                  ValueListenableBuilder<bool>(
                      valueListenable: inputController.showEmptyNotifier,
                      builder: (_, showEmpty, __) {
                        return ValueListenableBuilder<ProgrammingBlockModel?>(
                            valueListenable:
                                inputController.programmingBlockNotifier,
                            builder: (_, blockModel, __) {
                              return showEmpty
                                  ? InkWell(
                                      onTap: () async {
                                        await onValueOverviewTap(
                                          context,
                                          input?.defaultData,
                                          inputController,
                                        );
                                        programmingBlocks.onProjectChange?.call(
                                            programmingBlocks.projectModel);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 5),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3)),
                                        ),
                                        child: ValueListenableBuilder<
                                                Map<String, dynamic>>(
                                            valueListenable:
                                                inputController.valueNotifier,
                                            builder: (context, value, _) {
                                              return valueOverview(value);
                                            }),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            });
                      })
                ],
              ),
              ValueListenableBuilder<ProgrammingBlockModel?>(
                valueListenable: inputController.programmingBlockNotifier,
                builder: (_, blockModel, __) {
                  return blockModel != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 2, top: 1),
                          child: DraggableProgrammingBlock(
                            blockModel: () => blockModel,
                            removeOnDrag: true,
                            onDragCompleted: () {
                              inputController.showEmptyNotifier.value = false;
                            },
                            onDragStarted: () {
                              inputController.showEmptyNotifier.value = true;
                            },
                            child: programmingBlocks.buildBlockByModel(context,
                                blockModel: blockModel,
                                fromCreationSection: false),
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
              ValueListenableBuilder<Color?>(
                  valueListenable: enterBlockColorNotifier,
                  builder: (_, enterBlockColor, __) {
                    return enterBlockColor != null
                        ? PuzzleShadow(
                            puzzlePieceData: puzzlePieceData,
                            color: enterBlockColor,
                          )
                        : const SizedBox.shrink();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
