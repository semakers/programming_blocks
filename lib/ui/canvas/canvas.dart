import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/drag_and_drop/draggable_programming_block.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ProgrammingBlocksDependencyCanvas extends StatelessWidget {
  const ProgrammingBlocksDependencyCanvas({
    Key? key,
    this.backgroundCanvasColor,
    this.doubleTapAnimDuration,
    this.foregroundCanvasColor,
    this.opacityScrollBars,
    this.radiusScrollBars,
    this.scrollBarsColor,
    this.scrollWeight,
  }) : super(key: key);

  final Color? backgroundCanvasColor;
  final Duration? doubleTapAnimDuration;
  final Color? foregroundCanvasColor;
  final double? opacityScrollBars;
  final double? radiusScrollBars;
  final Color? scrollBarsColor;
  final double? scrollWeight;

  List<SingleCanvas> updateSingleCanvasList({
    required List<SingleCanvas> singleCanvasList,
    required List<ProgrammingBlocksDependencyCanvasModel> canvasList,
  }) {
    return canvasList.map((canvas) {
      final List<SingleCanvas> lastList =
          singleCanvasList.where((e) => e.canvasModel == canvas).toList();

      return lastList.isEmpty
          ? SingleCanvas(
              canvasModel: canvas,
              key: ValueKey<ProgrammingBlocksDependencyCanvasModel>(canvas),
              backgroundCanvasColor: backgroundCanvasColor,
              doubleTapAnimDuration: doubleTapAnimDuration,
              foregroundCanvasColor: foregroundCanvasColor,
              opacityScrollBars: opacityScrollBars,
              scrollBarsColor: scrollBarsColor,
              radiusScrollBars: radiusScrollBars,
              scrollWeight: scrollWeight,
            )
          : lastList.first;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey key = GlobalKey();
    final controller =
        ProgrammingBlocksDependency.of(context)!.canvasController;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
      Offset position = box.localToGlobal(Offset.zero);

      controller.topLeft = position;
    });
    List<SingleCanvas> singleCanvasList = [];

    return ValueListenableBuilder<List<ProgrammingBlocksDependencyCanvasModel>>(
        valueListenable: controller.functionsListListenable,
        builder: (context, functionsList, _) {
          final canvasList = functionsList;

          singleCanvasList = updateSingleCanvasList(
            singleCanvasList: singleCanvasList,
            canvasList: canvasList,
          );

          return ValueListenableBuilder<ProgrammingBlocksDependencyCanvasModel>(
              key: key,
              valueListenable: controller.currentCanvasListenable,
              builder: (_, canvasModel, __) {
                final sortedSingleCanvaslist = singleCanvasList
                    .where((element) => element.canvasModel != canvasModel)
                    .toList();
                sortedSingleCanvaslist.add(singleCanvasList.firstWhere(
                    (element) => element.canvasModel == canvasModel));

                controller.currentSingleCanvas = sortedSingleCanvaslist.last;

                return Stack(
                  children: sortedSingleCanvaslist,
                );
              });
        });
  }
}

class SingleCanvasController {
  Offset currentPosition = Offset.zero;
  double currentScale = 1.0;
}

class SingleCanvas extends InheritedWidget {
  SingleCanvas({
    Key? key,
    required this.canvasModel,
    required Color? backgroundCanvasColor,
    required Duration? doubleTapAnimDuration,
    required Color? foregroundCanvasColor,
    required double? opacityScrollBars,
    required double? radiusScrollBars,
    required Color? scrollBarsColor,
    required double? scrollWeight,
  })  : blocks = ValueNotifier(canvasModel.programmingBlocks),
        super(
            child: _SingleCanvas(
              canvasModel: canvasModel,
              backgroundCanvasColor: backgroundCanvasColor,
              doubleTapAnimDuration: doubleTapAnimDuration,
              foregroundCanvasColor: foregroundCanvasColor,
              opacityScrollBars: opacityScrollBars,
              radiusScrollBars: radiusScrollBars,
              scrollBarsColor: scrollBarsColor,
              scrollWeight: scrollWeight,
            ),
            key: key);

  final ValueNotifier<List<ProgrammingBlockModel>> blocks;
  final ProgrammingBlocksDependencyCanvasModel canvasModel;
  final SingleCanvasController controller = SingleCanvasController();

  static SingleCanvas? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<SingleCanvas>());
  }

  void update() {
    blocks.value =
        canvasModel.programmingBlocks.where((element) => true).toList();
  }

  set newBlock(ProgrammingBlockModel blockModel) {
    canvasModel.programmingBlocks.add(blockModel);
    update();
  }

  void removeBlock(
      {required ProgrammingBlockModel blockModel, bool waitRedraw = false}) {
    canvasModel.programmingBlocks.remove(blockModel);

    if (waitRedraw) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        blocks.value =
            canvasModel.programmingBlocks.where((element) => true).toList();
      });
    } else {
      blocks.value =
          canvasModel.programmingBlocks.where((element) => true).toList();
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class _SingleCanvas extends StatelessWidget {
  const _SingleCanvas({
    Key? key,
    required this.canvasModel,
    required this.backgroundCanvasColor,
    required this.doubleTapAnimDuration,
    required this.foregroundCanvasColor,
    required this.opacityScrollBars,
    required this.radiusScrollBars,
    required this.scrollBarsColor,
    required this.scrollWeight,
  }) : super(key: key);

  final ProgrammingBlocksDependencyCanvasModel canvasModel;
  final Color? backgroundCanvasColor;
  final Duration? doubleTapAnimDuration;
  final Color? foregroundCanvasColor;
  final double? opacityScrollBars;
  final double? radiusScrollBars;
  final Color? scrollBarsColor;
  final double? scrollWeight;

  @override
  Widget build(BuildContext context) {
    final singleCanvas = SingleCanvas.of(context);
    final _programmingBlocks = ProgrammingBlocksDependency.of(context)!;
    final listener = _programmingBlocks.panelController.listenerByConfig(
      uuid: canvasModel.functionUuid,
    );
    return ValueListenableBuilder<ConfigurationBlockModel?>(
        valueListenable: listener!,
        builder: (context, configModel, _) {
          return Zoom(
            key: UniqueKey(),
            canvasColor: foregroundCanvasColor ?? Colors.white,
            backgroundColor: backgroundCanvasColor ?? Colors.grey,
            doubleTapAnimDuration:
                doubleTapAnimDuration ?? const Duration(milliseconds: 300),
            opacityScrollBars: opacityScrollBars ?? 0.5,
            radiusScrollBars: radiusScrollBars ?? 4,
            colorScrollBars: scrollBarsColor ?? Colors.black12,
            scrollWeight: scrollWeight ?? 10,
            maxZoomHeight: configModel!.configArguments['height'].toDouble(),
            maxZoomWidth: configModel.configArguments['widht'].toDouble(),
            onPositionUpdate: (position) {
              singleCanvas?.controller.currentPosition = position;
            },
            onScaleUpdate: (_, scale) {
              singleCanvas?.controller.currentScale = scale;
            },
            child: ValueListenableBuilder<List<ProgrammingBlockModel>>(
                valueListenable: singleCanvas!.blocks,
                builder: (context, programmingBlocks, _) {
                  return Stack(
                    children: [
                      singleCanvas.canvasModel.functionUuid ==
                                  ProgrammingBlocksDependency.mainCanvasUuid &&
                              !_programmingBlocks.drawMainScope
                          ? const SizedBox.shrink()
                          : Positioned(
                              top: 10,
                              left: 10,
                              child: ScopeBlock(
                                blockModel: singleCanvas
                                    .canvasModel.functionScopeBlockModel,
                                nameBuilder: (_) => ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(minWidth: 75),
                                    child: Text(
                                      configModel.blockName,
                                    )),
                                panelBuilder: () => const SizedBox.shrink(),
                                color: _programmingBlocks
                                    .typeByName(name: 'FUNCTION')!
                                    .sectionData
                                    .color,
                                fromCreationSection: false,
                              ),
                            ),
                      ...programmingBlocks.map(
                        (e) {
                          return Positioned(
                            top: e.position.dy,
                            left: e.position.dx,
                            child: DraggableProgrammingBlock(
                              removeOnDrag: true,
                              blockModel: () => e,
                              child: ProgrammingBlocksDependency.of(context)!
                                  .buildBlockByModel(
                                context,
                                blockModel: e,
                                fromCreationSection: false,
                              ),
                            ),
                          );
                        },
                      ).toList()
                    ],
                  );
                }),
          );
        });
  }
}
