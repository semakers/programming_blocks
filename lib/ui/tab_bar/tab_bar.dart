import 'package:flutter/material.dart';
import 'package:programming_blocks/function_section/add_modify_function_dialog.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:flutter/gestures.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/add_modify_dialog/add_modify_dialog.dart';

class TabBar extends StatelessWidget {
  const TabBar({
    Key? key,
    this.functionTabsBuilder,
  }) : super(key: key);

  final Widget Function(BuildContext context, String tabName, bool selected)?
      functionTabsBuilder;

  Future<void> showModifyDialog(
    BuildContext context, {
    required String functionUuid,
  }) async {
    final programmingBlocks = ProgrammingBlocksDependency.of(context)!;
    final configurationBlockModel =
        programmingBlocks.panelController.configByuuid(uuid: functionUuid);
    final modified = await AddModifyFunctionDialog(
      functionConfigBlockModel: configurationBlockModel,
      defaultFunctionSize: programmingBlocks.defaultFuntionSize,
      onRemove: () {
        programmingBlocks.removeConfigurationBlockModel(
            configurationBlockModel: configurationBlockModel!);
        programmingBlocks.removeFunction(
            functionUuid:
                configurationBlockModel.configArguments['function_uuid']);
      },
    ).showAddModify(
      context,
      dialogType: DialogType.modify,
    );
    if (modified != null) {
      programmingBlocks.updateConfigurationBlockModel(
        configurationBlockModel: modified,
      );
      ProgrammingBlocksDependency.of(context)!.updateFunctionInfo(
        functionUuid: configurationBlockModel!.configArguments['function_uuid'],
        canvasModel: modified.toCanvasModel,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final programmingBlocks = ProgrammingBlocksDependency.of(context)!;
    final canvasController = programmingBlocks.canvasController;

    return ScrollConfiguration(
      behavior: MyCustomScrollBehavior(),
      child:
          ValueListenableBuilder<List<ProgrammingBlocksDependencyCanvasModel>>(
              valueListenable: canvasController.functionsListListenable,
              builder: (context, functionsList, _) {
                return ValueListenableBuilder<
                        ProgrammingBlocksDependencyCanvasModel>(
                    valueListenable: canvasController.currentCanvasListenable,
                    builder: (_, canvasModel, __) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: functionsList
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(right: 3.0),
                                    child: InkWell(
                                      onTap: () async {
                                        if (canvasController
                                                .currentCanvasListenable
                                                .value !=
                                            e) {
                                          canvasController.currentCanvas = e;
                                        } else {
                                          await showModifyDialog(context,
                                              functionUuid: e.functionUuid);
                                        }
                                      },
                                      child: functionTabsBuilder != null
                                          ? functionTabsBuilder!(context,
                                              e.title, canvasModel == e)
                                          : ProgrammingBlocksDependencyTab(
                                              selected: canvasModel == e,
                                              canvasModel: e,
                                            ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    });
              }),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
