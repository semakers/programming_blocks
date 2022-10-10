import 'package:flutter/material.dart';
import 'package:programming_blocks/models/puzzle_piece_data.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/ui/block_input/block_input_target_controller.dart';
import 'package:programming_blocks/ui/puzzle_piece/puzzle_out.dart';

class ReturnBlock extends StatelessWidget {
  const ReturnBlock({
    Key? key,
    required this.blockModel,
    required this.nameBuilder,
    required this.panelBuilder,
    required this.color,
    required this.fromCreationSection,
    required this.puzzlePieceData,
  }) : super(key: key);

  final ProgrammingBlockModel? blockModel;
  final Widget Function(ProgrammingBlockModel? blockModel) nameBuilder;
  final Widget Function() panelBuilder;
  final Color color;
  final bool fromCreationSection;
  final PuzzlePieceData puzzlePieceData;

  @override
  Widget build(BuildContext context) {
    final inputController = BlockInputTargetController.of(context);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: puzzlePieceData.size - 1,
          ),
          child: inputController == null
              ? SimpleBlock(
                  blockModel: blockModel,
                  nameBuilder: nameBuilder,
                  panelBuilder: panelBuilder,
                  color: color,
                )
              : Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  padding: const EdgeInsets.all(1),
                  child: SimpleBlock(
                    blockModel: blockModel,
                    nameBuilder: nameBuilder,
                    panelBuilder: panelBuilder,
                    color: color,
                  ),
                ),
        ),
        PuzzleOut(
          color: color,
          puzzlePieceData: puzzlePieceData,
        ),
      ],
    );
  }
}
