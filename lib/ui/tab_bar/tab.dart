import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/drag_and_drop/programming_block_drag_target.dart';

class ProgrammingBlocksDependencyTab extends StatelessWidget {
  const ProgrammingBlocksDependencyTab({
    Key? key,
    required this.canvasModel,
    required this.selected,
  }) : super(key: key);

  final ProgrammingBlocksDependencyCanvasModel canvasModel;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return BlockDragTarget(
      onBlockDroped: (blockModel) {
        final controller =
            ProgrammingBlocksDependency.of(context)!.canvasController;
        controller
            .currentSingleCanvas!.canvasModel.functionScopeBlockModel.blocks
            .insert(0, blockModel);
        controller.currentSingleCanvas!.update();
        return true;
      },
      onBlockEnter: (blockModel) {
        ProgrammingBlocksDependency.of(context)
            ?.canvasController
            .currentCanvas = canvasModel;
      },
      onBlockExit: (blockModel) {},
      child: Container(
        decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.grey,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(5.0),
              topRight: Radius.circular(
                selected ? 15.0 : 5.0,
              ),
            ),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0.5, 0),
                blurRadius: 1,
                color: Colors.black,
              )
            ]),
        padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 4.0,
          left: 4.0,
          right: 6.0,
        ),
        child: Text(
          canvasModel.title,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
