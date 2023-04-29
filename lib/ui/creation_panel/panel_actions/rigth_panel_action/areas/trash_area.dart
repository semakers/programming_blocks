import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/drag_and_drop/programming_block_drag_target.dart';

class TrashArea extends StatelessWidget {
  const TrashArea({
    Key? key,
    required this.trashBuilder,
  }) : super(key: key);

  final Widget Function(bool onBlockEnter)? trashBuilder;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> onBlockEnterListeneable =
        ValueNotifier<bool>(false);
    final programmingBlocks = ProgrammingBlocksDependency.of(context)!;
    return BlockDragTarget(
      onBlockDroped: (blockModel) {
        onBlockEnterListeneable.value = false;
        programmingBlocks.playSound('delete.mp3');
        return false;
      },
      onBlockEnter: (blockmodel) {
        onBlockEnterListeneable.value = true;
      },
      onBlockExit: (blockModel) {
        onBlockEnterListeneable.value = false;
      },
      child: ValueListenableBuilder<bool>(
          valueListenable: onBlockEnterListeneable,
          builder: (context, onBlockEnter, _) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: trashBuilder != null
                  ? trashBuilder!(onBlockEnter)
                  : Icon(
                      Icons.delete,
                      size: 50.0,
                      color: onBlockEnter ? Colors.red : Colors.black,
                    ),
            );
          }),
    );
  }
}
