import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart' hide TabBar;
import 'package:programming_blocks/models/block_type.dart';
import 'package:programming_blocks/function_section/function_block_type.dart';
import 'package:programming_blocks/function_section/function_scope_block_model.dart';
import 'package:programming_blocks/function_section/function_section.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/ui/creation_panel/programming_block_run_backup.dart';
import 'package:programming_blocks/models/project_model_singleton_builder.dart';
import 'package:programming_blocks/ui/block_input/block_input_target_controller.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/creation_panel/section/types/divided_section.dart';
import 'package:programming_blocks/ui/creation_panel/section/types/simple_section.dart';
import 'package:programming_blocks/ui/creation_panel/section/types/typed_section.dart';
import 'package:programming_blocks/ui/programming_blocks/block_by_shape.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/execution_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_block_controller.dart';
import 'package:programming_blocks/ui/programming_blocks/programming_block.dart';
import 'package:collection/collection.dart';

import 'ui/programming_blocks/controllers/programming_block_controller.dart';

class ProgrammingBlocksDependency extends InheritedWidget {
  ProgrammingBlocksDependency({
    this.backgroundCanvasColor,
    Curve? creationPanelAnimationCurve,
    Duration? creationPanelAnimationDuration,
    Color? creationPanelBackgroundColor,
    double? creationPanelHeight,
    Widget Function()? creationPanelOpenCloseBuilder,
    this.creationSectionButtonBuilder,
    this.defaultFuntionSize = 2000,
    this.doubleTapAnimDuration,
    int dragDelay = 100,
    this.drawMainScope = true,
    this.enableFunctions = true,
    this.foregroundCanvasColor,
    Color? functionsSectionColor,
    this.functionTabsBuilder,
    this.injectorChild,
    Key? key,
    this.mainFunctionName = 'Main',
    this.onChangeRunningState,
    this.onProjectChange,
    this.opacityScrollBars,
    ProgrammingBlocksProjectModel? projectModel,
    this.radiusScrollBars,
    Widget Function(Color? enterBlockColor)? runBuilder,
    this.scrollBarsColor,
    this.scrollBarsWeight,
    required this.sections,
    Widget Function()? stopBuilder,
    Widget Function(bool onBlockEnter)? trashBuilder,
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
        super(
            key: key,
            child: injectorChild ??
                CreationPanel(
                  trashBuilder: trashBuilder,
                  runBuilder: runBuilder,
                  stopBuilder: stopBuilder,
                  animationCurve: creationPanelAnimationCurve,
                  animationDuration: creationPanelAnimationDuration,
                  backgorundColor: creationPanelBackgroundColor,
                  creationSectionButtonBuilder: creationSectionButtonBuilder,
                  height: creationPanelHeight ?? 250,
                  openCloseBuilder: creationPanelOpenCloseBuilder,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (enableFunctions == true)
                        TabBar(
                          functionTabsBuilder: functionTabsBuilder,
                        ),
                      Expanded(
                        child: ProgrammingBlocksDependencyCanvas(
                            foregroundCanvasColor: foregroundCanvasColor,
                            backgroundCanvasColor: backgroundCanvasColor,
                            scrollBarsColor: scrollBarsColor,
                            doubleTapAnimDuration: doubleTapAnimDuration,
                            opacityScrollBars: opacityScrollBars,
                            radiusScrollBars: radiusScrollBars,
                            scrollWeight: scrollBarsWeight),
                      ),
                    ],
                  ),
                )) {
    blockTypes.clear();
    blockTypes.addAll(_findBlockTypes());
  }

  final bool enableFunctions;
  final double defaultFuntionSize;
  final List<BlockType> blockTypes = [];
  final CanvasController canvasController;
  final Widget Function(
      BuildContext context,
      CreationSectionData creationSectionData,
      bool selected)? creationSectionButtonBuilder;
  final Widget Function(BuildContext context, String tabName, bool selected)?
      functionTabsBuilder;
  final Widget? injectorChild;
  final CreationPanelController panelController;
  final ProgrammingBlocksProjectModel _projectModel;
  final List<CreationSection> sections;
  final Color? foregroundCanvasColor;
  final Color? backgroundCanvasColor;
  final Color? scrollBarsColor;
  final Duration? doubleTapAnimDuration;
  final double? opacityScrollBars;
  final double? radiusScrollBars;
  final double? scrollBarsWeight;
  final String mainFunctionName;
  final int _dragDelay;
  final bool drawMainScope;
  final ProgrammingBlockRunBackupController runBackupController =
      ProgrammingBlockRunBackupController();
  final Function(
    RunningState runningState,
  )? onChangeRunningState;
  final Function(ProgrammingBlocksProjectModel projectModel)? onProjectChange;

  static const String noConfigUUid = 'NO_CONFIG_UUID';
  static const String mainCanvasUuid = 'MAIN_CANVAS_UUID';

  ProgrammingBlocksProjectModel get projectModel => _projectModel;

  int get dragDelay => _dragDelay;
  final player = AudioPlayer();

  void paySound(String assetName) {
    try {
      player
          .play(
            AssetSource(
              assetName,
            ),
          )
          .then((value) => null);
    } catch (_) {}
  }

  static ProgrammingBlocksDependency? of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<ProgrammingBlocksDependency>());
  }

  void restoreRunBackUp() {
    runBackupController.restoreProgrammingBlock();
    onProjectChange?.call(projectModel);
  }

  bool _hasType(
      {required List<BlockType> blockTypes, required BlockType blockType}) {
    for (final type in blockTypes) {
      if (type.name == blockType.name) {
        return true;
      }
    }
    return false;
  }

  void updateConfigurationBlockModel({
    required ConfigurationBlockModel configurationBlockModel,
  }) {
    final old = projectModel.configurationModels
        .firstWhere((element) => element.uuid == configurationBlockModel.uuid);

    final oldIndex = projectModel.configurationModels.indexOf(old);

    projectModel.configurationModels[oldIndex] = configurationBlockModel;
    final listener = panelController.listenerByConfig(
      uuid: configurationBlockModel.uuid,
    );
    listener!.value = configurationBlockModel;
    panelController.updateConfigList(
      configList: projectModel.configurationModels,
    );
    onProjectChange?.call(projectModel);
  }

  void removeConfigurationBlockModel({
    required ConfigurationBlockModel configurationBlockModel,
  }) {
    final listener =
        panelController.listenerByConfig(uuid: configurationBlockModel.uuid);
    listener!.value = null;
    projectModel.configurationModels.remove(configurationBlockModel);
    panelController.removeConfigModel(
      configModel: configurationBlockModel,
    );
    onProjectChange?.call(projectModel);
  }

  List<ConfigurationBlockModel> configurationBlockModelsByType({
    required String typeName,
  }) {
    return projectModel.configurationModels
        .where(
          (element) => element.typeName == typeName,
        )
        .toList();
  }

  void removeBlock(
    BuildContext context, {
    required ProgrammingBlockModel? blockModel,
    bool waitRedraw = false,
  }) {
    final scopeBlock = ScopeBlockController.of(context);
    final blockInput = BlockInputTargetController.of(context);

    if (blockInput != null) {
      if (waitRedraw) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          blockInput.removeBlock();
        });
      } else {
        blockInput.removeBlock();
      }
    }
    if (scopeBlock != null) {
      if (waitRedraw) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scopeBlock.removeBlock(
            blockModel: blockModel!,
          );
        });
      } else {
        scopeBlock.removeBlock(
          blockModel: blockModel!,
        );
      }
    } else {
      SingleCanvas.of(context)!
          .removeBlock(blockModel: blockModel!, waitRedraw: waitRedraw);
    }
  }

  ConfigurationBlockModel? configurationBlockModelByUuid({
    required String uuid,
  }) {
    return projectModel.configurationModels
        .firstWhereOrNull((element) => element.uuid == uuid);
  }

  void removeFunction({
    required String functionUuid,
  }) {
    if (canvasController.currentCanvasListenable.value.functionUuid ==
        functionUuid) {
      canvasController.currentCanvas = projectModel.functionsCanvas.first;
    }
    projectModel.functionsCanvas.remove(projectModel.functionsCanvas
        .firstWhere((element) => element.functionUuid == functionUuid));
    canvasController.functionsListListenable.value =
        projectModel.functionsCanvas.where((element) => true).toList();
    onProjectChange?.call(projectModel);
  }

  void updateFunctionInfo({
    required String functionUuid,
    required ProgrammingBlocksDependencyCanvasModel canvasModel,
  }) {
    for (final ProgrammingBlocksDependencyCanvasModel element
        in projectModel.functionsCanvas) {
      if (element.functionUuid == functionUuid) {
        final canvas = projectModel.functionsCanvas
            .firstWhere((element) => element.functionUuid == functionUuid);
        canvas.title = canvasModel.title;
        canvas.size = canvasModel.size;
      }
    }

    if (functionUuid == ProgrammingBlocksDependency.mainCanvasUuid) {
      projectModel.functionsCanvas.first.title = canvasModel.title;
      projectModel.functionsCanvas.first.size = canvasModel.size;
    }

    canvasController.functionsListListenable.value =
        projectModel.functionsCanvas.where((element) => true).toList();
    onProjectChange?.call(projectModel);
  }

  void addConfigurationBlockModel({
    required ConfigurationBlockModel configurationBlockModel,
  }) {
    panelController.configListeners.add(ValueNotifier(configurationBlockModel));
    projectModel.configurationModels.add(configurationBlockModel);
    panelController.updateConfigList(
        configList: projectModel.configurationModels);
    onProjectChange?.call(projectModel);
  }

  Future<void> executeBlock({
    required ProgrammingBlockModel blockModel,
  }) {
    late ProgrammingBlockModel _blockModel;

    FunctionScopeBlockModel? functionBlockModel;
    if (blockModel.type == FunctionBlockType.typeName) {
      functionBlockModel = canvasController.blockModelByFunctionUuid(
          functionUuid: blockModel.configurationUuid);
    }
    _blockModel = functionBlockModel ?? blockModel;

    BlockType? blockType = typeByBlockModel(
      blockModel: _blockModel,
    );

    return blockType!.execute(
      ExecutionBlockController(
        blockModel: _blockModel,
        programmingBlocks: this,
      ),
    );
  }

  Future<dynamic> readBlock({
    required ProgrammingBlockModel blockModel,
  }) {
    BlockType? blockType = typeByBlockModel(
      blockModel: blockModel,
    );

    return blockType!.readData(
      ReadBlockController(
        blockModel: blockModel,
        configBlockModel: panelController.configByuuid(
          uuid: blockModel.configurationUuid,
        ),
        programmingBlocks: this,
      ),
    );
  }

  BlockType? typeByName({
    required String? name,
  }) {
    BlockType? _blockType;

    for (final blockType in blockTypes) {
      if (blockType.name == name) {
        _blockType = blockType;
      }
    }
    return _blockType;
  }

  BlockType? typeByBlockModel({
    required ProgrammingBlockModel? blockModel,
  }) {
    BlockType? _blockType = typeByName(
      name: blockModel?.type,
    );
    return _blockType;
  }

  Color colorByBlockModel({required ProgrammingBlockModel blockModel}) {
    final blockType = typeByBlockModel(blockModel: blockModel);

    if (blockType != null) {
      return blockType.sectionData.color;
    } else {
      return Colors.black;
    }
  }

  void _typesBySection(
      {required List<BlockType> blockTypes, required CreationSection section}) {
    if (section is SimpleSection) {
      for (final blockType in section.blocktypes) {
        if (!_hasType(blockTypes: blockTypes, blockType: blockType)) {
          blockTypes.add(blockType);
        }
      }
    } else if (section is TypedSection) {
      if (!_hasType(
          blockTypes: blockTypes, blockType: section.instancesblockType)) {
        blockTypes.add(section.instancesblockType);
      }
      for (final blockType in section.instancesFunctionsBlockTypes) {
        if (!_hasType(blockTypes: blockTypes, blockType: blockType)) {
          blockTypes.add(blockType);
        }
      }
    }
  }

  List<BlockType> _findBlockTypes() {
    List<BlockType> blockTypes = [];

    for (final section in panelController.sections) {
      if (section is DividedSection) {
        for (final subSection in section.subSections.values) {
          _typesBySection(
            blockTypes: blockTypes,
            section: subSection,
          );
        }
      } else {
        _typesBySection(
          blockTypes: blockTypes,
          section: section,
        );
      }
    }
    return blockTypes;
  }

  Widget buildBlockByModel(
    BuildContext context, {
    required ProgrammingBlockModel blockModel,
    required bool fromCreationSection,
  }) {
    BlockType? blockType = typeByBlockModel(blockModel: blockModel);

    if (blockType == null) {
      return const Text(
        'ERROR',
        style: TextStyle(
          color: Colors.red,
        ),
      );
    } else {
      return BlockByShape.build(
        puzzlePieceData: blockType.puzzlePieceData,
        blockModel: blockModel,
        nameBuilder: (_blockModel) {
          return Builder(builder: (context) {
            return blockType.nameBuilder(ProgrammingBlockController(
                programmingBlock: ProgrammingBlock.of(context)!));
          });
        },
        panelBuilder: () {
          return Builder(builder: (context) {
            return blockType.panelBuilder(ProgrammingBlockController(
                programmingBlock: ProgrammingBlock.of(context)!));
          });
        },
        color: blockType.sectionData.color,
        shape: blockType.shape,
        fromCreationSection: fromCreationSection,
      );
    }
  }

  @override
  bool updateShouldNotify(ProgrammingBlocksDependency oldWidget) {
    return true;
  }
}
