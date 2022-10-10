library programming_blocks;

import 'package:flutter/material.dart';
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/function_section/function_section.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/models/project_model_singleton_builder.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';

export 'models/configuration_block_model.dart';
export 'models/programming_block_selector_model.dart';
export 'models/programming_block_input_model.dart';
export 'models/programming_block_model.dart';
export 'models/programming_blocks_canvas_model.dart';
export 'models/programming_blocks_project_model.dart';
export 'ui/canvas/canvas.dart';
export 'ui/canvas/canvas_controller.dart';
export 'ui/creation_panel/creation_panel.dart';
export 'ui/creation_panel/section/creation_section.dart';
export 'ui/programming_blocks/return_block.dart';
export 'ui/programming_blocks/simple_block.dart';
export 'ui/programming_blocks/scope_block.dart';
export 'ui/tab_bar/tab.dart';
export 'ui/tab_bar/tab_bar.dart';
export 'ui/variable_dialog/variable_dialog.dart';
export 'base_sections/follow/follow_section.dart';
export 'base_sections/logic/logic_section.dart';
export 'base_sections/number/numbers_section.dart';

enum RunningState {
  running,
  stoped,
}

class ProgrammingBlocks extends StatelessWidget {
  ProgrammingBlocks({
    Key? key,
    this.backgroundCanvasColor,
    this.creationPanelAnimationCurve,
    this.creationPanelAnimationDuration,
    this.creationPanelBackgroundColor,
    this.creationPanelHeight,
    this.creationPanelOpenCloseBuilder,
    this.creationSectionButtonBuilder,
    this.defaultFuntionSize = 2000,
    this.doubleTapAnimDuration,
    int dragDelay = 100,
    this.drawMainScope = true,
    this.enableFunctions = true,
    this.foregroundCanvasColor,
    this.functionsSectionColor,
    this.functionTabsBuilder,
    this.mainFunctionName = 'Main',
    this.onChangeRunningState,
    this.onProjectChange,
    this.opacityScrollBars,
    ProgrammingBlocksProjectModel? projectModel,
    this.radiusScrollBars,
    this.runBuilder,
    this.scrollBarsColor,
    this.scrollBarsWeight,
    required this.sections,
    this.stopBuilder,
    this.trashBuilder,
  })  : _dragDelay = dragDelay < 100 ? 100 : dragDelay,
        _projectModel = projectModel ??
            ProjectModelSingletonBuilder().build(
                defaultFuntionSize: defaultFuntionSize,
                mainFunctionName: mainFunctionName,
                drawMainScope: drawMainScope),
        canvasController = CanvasController(
          projectModel: projectModel ??
              ProjectModelSingletonBuilder().build(
                  defaultFuntionSize: defaultFuntionSize,
                  mainFunctionName: mainFunctionName,
                  drawMainScope: drawMainScope),
        ),
        panelController = CreationPanelController(
          sections: [
            ...sections,
            FunctionsSection(
              color: functionsSectionColor,
            ),
          ],
          configBlockModels: (projectModel ??
                  ProjectModelSingletonBuilder().build(
                    defaultFuntionSize: defaultFuntionSize,
                    mainFunctionName: mainFunctionName,
                    drawMainScope: drawMainScope,
                  ))
              .configurationModels,
        ),
        super(key: key);

  final List<BlockType> blockTypes = [];
  final int _dragDelay;
  final ProgrammingBlocksProjectModel _projectModel;
  final Color? backgroundCanvasColor;
  final CanvasController canvasController;
  final Curve? creationPanelAnimationCurve;
  final Duration? creationPanelAnimationDuration;
  final Color? creationPanelBackgroundColor;
  final double? creationPanelHeight;
  final Widget Function()? creationPanelOpenCloseBuilder;
  final Widget Function(
      BuildContext context,
      CreationSectionData creationSectionData,
      bool selected)? creationSectionButtonBuilder;
  final double defaultFuntionSize;
  final Duration? doubleTapAnimDuration;
  final bool drawMainScope;
  final bool enableFunctions;
  final Color? foregroundCanvasColor;
  final Color? functionsSectionColor;
  final Widget Function(BuildContext context, String tabName, bool selected)?
      functionTabsBuilder;
  final String mainFunctionName;
  final Function(
    RunningState runningState,
  )? onChangeRunningState;
  final Function(ProgrammingBlocksProjectModel projectModel)? onProjectChange;
  final double? opacityScrollBars;
  final CreationPanelController panelController;
  final double? radiusScrollBars;
  final Widget Function(Color? enterBlockColor)? runBuilder;
  final Color? scrollBarsColor;
  final double? scrollBarsWeight;
  final List<CreationSection> sections;
  final Widget Function()? stopBuilder;
  final Widget Function(bool onBlockEnter)? trashBuilder;

  @override
  Widget build(BuildContext context) {
    return ProgrammingBlocksDependency(
      backgroundCanvasColor: backgroundCanvasColor,
      creationPanelAnimationCurve: creationPanelAnimationCurve,
      creationPanelAnimationDuration: creationPanelAnimationDuration,
      creationPanelBackgroundColor: creationPanelBackgroundColor,
      creationPanelHeight: creationPanelHeight,
      creationPanelOpenCloseBuilder: creationPanelOpenCloseBuilder,
      creationSectionButtonBuilder: creationSectionButtonBuilder,
      defaultFuntionSize: defaultFuntionSize,
      doubleTapAnimDuration: doubleTapAnimDuration,
      dragDelay: _dragDelay,
      drawMainScope: drawMainScope,
      enableFunctions: enableFunctions,
      foregroundCanvasColor: foregroundCanvasColor,
      functionTabsBuilder: functionTabsBuilder,
      key: key,
      sections: sections,
      projectModel: _projectModel,
      mainFunctionName: mainFunctionName,
      onChangeRunningState: onChangeRunningState,
      onProjectChange: onProjectChange,
      opacityScrollBars: opacityScrollBars,
      radiusScrollBars: radiusScrollBars,
      runBuilder: runBuilder,
      scrollBarsColor: scrollBarsColor,
      scrollBarsWeight: scrollBarsWeight,
      stopBuilder: stopBuilder,
      trashBuilder: trashBuilder,
    );
  }
}
