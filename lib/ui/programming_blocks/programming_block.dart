import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';

class ProgrammingBlock extends InheritedWidget {
  ProgrammingBlock({
    Key? key,
    required Widget Function() builder,
    required this.blockModel,
    required this.color,
  })  : panelArgumentsNotifier = ValueNotifier(
          blockModel?.panelArguments ?? {},
        ),
        super(
          child: Builder(builder: (context) {
            final programmingBlocks = ProgrammingBlocksDependency.of(context)!;
            return blockModel?.configurationUuid !=
                        ProgrammingBlocksDependency.noConfigUUid &&
                    blockModel?.configurationUuid != null
                ? ValueListenableBuilder<ConfigurationBlockModel?>(
                    valueListenable:
                        programmingBlocks.panelController.listenerByConfig(
                      uuid: blockModel!.configurationUuid,
                    )!,
                    builder: (_, configurationBlockModel, __) {
                      blockModel.name =
                          configurationBlockModel?.blockName ?? '';
                      if (configurationBlockModel == null) {
                        programmingBlocks.removeBlock(
                          context,
                          blockModel: blockModel,
                          waitRedraw: true,
                        );
                        return const SizedBox.shrink();
                      }
                      return builder();
                    })
                : builder();
          }),
          key: key,
        );

  final ProgrammingBlockModel? blockModel;
  final Color color;
  final ValueNotifier<Map<String, dynamic>> panelArgumentsNotifier;

  static ProgrammingBlock? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProgrammingBlock>();
  }

  @override
  bool updateShouldNotify(ProgrammingBlock oldWidget) {
    return true;
  }

  ProgrammingBlockInputModel? getBlockInput({
    required String key,
  }) {
    final auxList = (blockModel?.inputs ?? [])
        .where((element) => element.key == key)
        .toList();

    if (auxList.isEmpty) {
      return null;
    } else {
      return auxList.first;
    }
  }

  void updateBlockInput({
    required ProgrammingBlockInputModel blockInput,
  }) {
    final aux = getBlockInput(key: blockInput.key);
    if (aux == null) {
      blockModel?.inputs.add(
        blockInput,
      );
    } else {
      aux.programmingBlock = blockInput.programmingBlock;
    }
  }

  void refreshPanel() {
    Map<String, dynamic> newArguments = {};
    newArguments.addAll(blockModel?.panelArguments ?? {});
    panelArgumentsNotifier.value = newArguments;
  }

  ProgrammingBlockSelectorModel? getSelector({
    required String key,
  }) {
    final auxList = (blockModel?.selectors ?? [])
        .where((element) => element.key == key)
        .toList();

    if (auxList.isEmpty) {
      return null;
    } else {
      return auxList.first;
    }
  }

  void updateSelector({
    required ProgrammingBlockSelectorModel selectorModel,
  }) {
    final auxList = blockModel?.selectors ??
        [].where((element) => element.key == selectorModel.key).toList();

    if (auxList.isEmpty) {
      blockModel?.selectors.add(selectorModel);
    } else {
      for (final element in auxList) {
        element.data = selectorModel.data;
      }
    }
  }
}
