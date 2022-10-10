import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/drag_and_drop/draggable_programming_block.dart';
import 'package:programming_blocks/ui/drag_and_drop/programming_block_drag_target.dart';
import 'package:programming_blocks/ui/programming_blocks/programming_block.dart';

class SimpleBlock extends StatelessWidget {
  const SimpleBlock({
    Key? key,
    required this.blockModel,
    required this.nameBuilder,
    required this.panelBuilder,
    required this.color,
    this.headerOfScopeBlock = false,
  }) : super(key: key);

  final ProgrammingBlockModel? blockModel;
  final Widget Function(ProgrammingBlockModel? blockModel) nameBuilder;
  final Widget Function() panelBuilder;
  final Color color;
  final bool headerOfScopeBlock;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return _DragTargetBody(
        headerOfScopeBlock: headerOfScopeBlock,
        color: color,
        nameBuilder: nameBuilder,
        panelBuilder: panelBuilder,
        blockModel: blockModel,
      );
    });
  }
}

class _DragTargetBody extends StatelessWidget {
  const _DragTargetBody({
    Key? key,
    required this.headerOfScopeBlock,
    required this.color,
    required this.nameBuilder,
    required this.panelBuilder,
    required this.blockModel,
  }) : super(key: key);

  final bool headerOfScopeBlock;
  final Color color;
  final Widget Function(ProgrammingBlockModel? blockModel) nameBuilder;
  final Widget Function() panelBuilder;
  final ProgrammingBlockModel? blockModel;

  @override
  Widget build(BuildContext context) {
    final scopeBlock = ScopeBlockController.of(context);
    return headerOfScopeBlock || scopeBlock == null
        ? _Body(
            color: color,
            headerOfScopeBlock: headerOfScopeBlock,
            nameBuilder: nameBuilder,
            panelBuilder: panelBuilder,
            blockModel: blockModel,
          )
        : BlockDragTarget(
            onBlockEnter: (enterBlockModel) {
              if (enterBlockModel.returnType == null) {
                scopeBlock.showDivider(
                  blockModel: blockModel!,
                );
              }
            },
            onBlockExit: (_) {
              scopeBlock.hideDivider();
            },
            onBlockDroped: (dropedBlockModel) {
              if (dropedBlockModel.returnType == null) {
                scopeBlock.addBlock(
                  targetBlockModel: blockModel!,
                  newBlockModel: dropedBlockModel,
                );
              } else {
                ProgrammingBlocksDependency.of(context)!
                    .canvasController
                    .currentSingleCanvas!
                    .newBlock = dropedBlockModel;
              }
              return true;
            },
            child: _Body(
              color: color,
              headerOfScopeBlock: headerOfScopeBlock,
              nameBuilder: nameBuilder,
              panelBuilder: panelBuilder,
              blockModel: blockModel,
            ),
          );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key? key,
    required this.color,
    required this.headerOfScopeBlock,
    required this.nameBuilder,
    required this.panelBuilder,
    required this.blockModel,
  }) : super(key: key);

  final ProgrammingBlockModel? blockModel;
  final Color color;
  final bool headerOfScopeBlock;
  final Widget Function(ProgrammingBlockModel? blockModel) nameBuilder;
  final Widget Function() panelBuilder;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final GlobalKey globalKey = GlobalKey();

  void updateHeaderSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final draggableBlock = DraggableProgrammingBlock.of(context);
      if (draggableBlock != null) {
        final size =
            (globalKey.currentContext!.findRenderObject()! as RenderBox).size;
        draggableBlock.headerSizeNotifier.value = size;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateHeaderSize();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: globalKey,
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 5.0,
      ),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: widget.headerOfScopeBlock
            ? const BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              )
            : const BorderRadius.all(
                Radius.circular(4.0),
              ),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.nameBuilder(
              widget.blockModel,
            ),
            ValueListenableBuilder<Map<String, dynamic>>(
                valueListenable:
                    ProgrammingBlock.of(context)?.panelArgumentsNotifier ??
                        ValueNotifier(
                          {},
                        ),
                builder: (context, panelArguments, _) {
                  updateHeaderSize();
                  return widget.panelBuilder();
                }),
          ],
        ),
      ),
    );
  }
}
