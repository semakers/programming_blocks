import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:programming_blocks/function_section/function_scope_block_model.dart';
import 'package:programming_blocks/programming_blocks.dart';

class CanvasController {
  CanvasController({
    required this.projectModel,
  })  : currentCanvasListenable = ValueNotifier(
          projectModel.functionsCanvas.first,
        ),
        functionsListListenable = ValueNotifier(
          projectModel.functionsCanvas,
        );

  Completer<ProgrammingBlockModel>? blocksBuffer;
  final ValueNotifier<ProgrammingBlocksDependencyCanvasModel>
      currentCanvasListenable;
  final ValueNotifier<List<ProgrammingBlocksDependencyCanvasModel>>
      functionsListListenable;
  SingleCanvas? currentSingleCanvas;

  late Offset topLeft;
  final ProgrammingBlocksProjectModel projectModel;

  set currentCanvas(ProgrammingBlocksDependencyCanvasModel canvasModel) {
    currentCanvasListenable.value = canvasModel;
  }

  void refreshCanvasList() {
    functionsListListenable.value =
        functionsListListenable.value.where((element) => true).toList();
  }

  Offset fixedPosition(Offset position) {
    return ((position -
            topLeft -
            currentSingleCanvas!.controller.currentPosition) *
        (1.0 / currentSingleCanvas!.controller.currentScale));
  }

  FunctionScopeBlockModel? blockModelByFunctionUuid(
      {required String functionUuid}) {
    final canvasModelsList = functionsListListenable.value;
    final FunctionScopeBlockModel? blockModel = canvasModelsList
        .firstWhereOrNull((element) => element.functionUuid == functionUuid)
        ?.functionScopeBlockModel;
    return blockModel;
  }
}
