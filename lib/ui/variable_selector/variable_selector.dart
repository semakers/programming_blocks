import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/programming_blocks/programming_block.dart';

class VariableSelector extends StatelessWidget {
  const VariableSelector({
    Key? key,
    required this.variableType,
    required this.textColor,
  }) : super(
          key: key,
        );

  final String variableType;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final programmingBlock = ProgrammingBlock.of(context)!;
    final programmingBlocks = ProgrammingBlocksDependency.of(context)!;

    final options = ProgrammingBlocksDependency.of(context)!
        .configurationBlockModelsByType(typeName: variableType)
        .map((e) => e.uuid);

    if (options.isEmpty) {
      return const SizedBox.shrink();
    }

    ValueNotifier<String> selectedNotifier = ValueNotifier(options.first);

    final selector =
        programmingBlock.getSelector(key: '${variableType}_SELECTION');
    if (selector != null) {
      selectedNotifier.value = selector.data;
    } else {
      programmingBlock.updateSelector(
        selectorModel: ProgrammingBlockSelectorModel(
          data: options.first,
          key: '${variableType}_SELECTION',
        ),
      );
    }
    return ValueListenableBuilder<String>(
      valueListenable: selectedNotifier,
      builder: (_, selected, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withAlpha(20),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  3.0,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SizedBox(
              height: 25,
              child: ValueListenableBuilder<List<ConfigurationBlockModel?>>(
                  valueListenable:
                      programmingBlocks.panelController.configListListeneble,
                  builder: (_, configlist, __) {
                    if (configlist
                        .where((element) => element?.uuid == selected)
                        .isEmpty) {
                      programmingBlocks.removeBlock(
                        context,
                        blockModel: programmingBlock.blockModel,
                        waitRedraw: true,
                      );
                      return const SizedBox.shrink();
                    }

                    return DropdownButton<String>(
                      style: TextStyle(color: textColor),
                      focusColor: Colors.transparent,
                      iconEnabledColor: textColor,
                      dropdownColor: programmingBlock.color,
                      value: selected,
                      underline: const SizedBox.shrink(),
                      items: configlist
                          .where(
                            (element) => element?.typeName == variableType,
                          )
                          .map(
                            (e) => e!.uuid,
                          )
                          .map((e) => DropdownMenuItem(
                              child: Text(
                                programmingBlocks.panelController
                                        .listenerByConfig(
                                          uuid: e,
                                        )
                                        ?.value
                                        ?.blockName ??
                                    '',
                                style: TextStyle(
                                  color: textColor,
                                ),
                              ),
                              value: e))
                          .toList(),
                      onChanged: (data) {
                        selectedNotifier.value = data!;
                        programmingBlock.updateSelector(
                          selectorModel: ProgrammingBlockSelectorModel(
                            data: data,
                            key: '${variableType}_SELECTION',
                          ),
                        );
                      },
                    );
                  }),
            ),
          ),
        );
      },
    );
  }
}
