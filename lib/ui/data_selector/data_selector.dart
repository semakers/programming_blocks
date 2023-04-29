import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/programming_blocks/programming_block.dart';

abstract class DataSelector extends StatelessWidget {
  const DataSelector({
    Key? key,
    required this.options,
    required this.dataSelectorKey,
    required this.textColor,
    this.defaultSelected,
  }) : super(
          key: key,
        );

  final List<String> options;
  final String dataSelectorKey;
  final Color textColor;
  final String? defaultSelected;

  @override
  Widget build(BuildContext context) {
    final programmingBlock = ProgrammingBlock.of(context)!;
    final programmingBlocks = ProgrammingBlocksDependency.of(context)!;
    ValueNotifier<String> selectedNotifier =
        ValueNotifier(defaultSelected ?? options.first);
    final selector = programmingBlock.getSelector(key: dataSelectorKey);
    if (selector != null) {
      selectedNotifier.value = selector.data;
    } else {
      programmingBlock.updateSelector(
        selectorModel: ProgrammingBlockSelectorModel(
          data: defaultSelected ?? options.first,
          key: dataSelectorKey,
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
              child: SizedBox(
                height: 25,
                child: DropdownButton<String>(
                  style: TextStyle(color: textColor),
                  focusColor: Colors.transparent,
                  iconEnabledColor: textColor,
                  dropdownColor: programmingBlock.color,
                  value: selected,
                  underline: const SizedBox.shrink(),
                  items: options
                      .map((e) => DropdownMenuItem(
                          child: dataName(
                            e,
                          ),
                          value: e))
                      .toList(),
                  onChanged: (data) {
                    selectedNotifier.value = data!;
                    programmingBlock.updateSelector(
                      selectorModel: ProgrammingBlockSelectorModel(
                        data: data,
                        key: dataSelectorKey,
                      ),
                    );
                    programmingBlocks.onProjectChange
                        ?.call(programmingBlocks.projectModel);
                  },
                ),
              ),
            ),
          );
        });
  }

  Widget dataName(String data);
}
