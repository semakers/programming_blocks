import 'dart:async';

import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks.dart';

abstract class VariableDialog<T> extends StatelessWidget {
  VariableDialog({
    Key? key,
    required this.actionLabel,
    required this.canvasDialog,
    required this.validator,
    this.configBlockModel,
    this.enableRemove = false,
    this.defaultValue = '',
  }) : super(key: key);

  final String? Function(String value) validator;
  final String actionLabel;
  final bool canvasDialog;
  final ConfigurationBlockModel? configBlockModel;
  final String defaultValue;
  final bool enableRemove;

  final Completer<T?> completer = Completer();
  final ValueNotifier<bool> enableAddModifyNotifier = ValueNotifier(false);
  final TextEditingController nameController = TextEditingController();
  final ValueNotifier<String?> nameErrorNotifier = ValueNotifier(null);
  final FocusNode nameFocusNode = FocusNode();
  final TextEditingController valueController = TextEditingController();
  final ValueNotifier<String?> valueErrorNotifier = ValueNotifier(null);
  final FocusNode valueFocusNode = FocusNode();

  bool isValidForm() {
    if (canvasDialog) {
      return valueErrorNotifier.value == null &&
          valueController.text.isNotEmpty;
    } else {
      return nameErrorNotifier.value == null &&
          valueErrorNotifier.value == null &&
          nameController.text.isNotEmpty &&
          valueController.text.isNotEmpty;
    }
  }

  void onAction(BuildContext context);

  void removeCallback(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    if (canvasDialog) {
      valueController.text = defaultValue;
    } else {
      nameController.text = configBlockModel?.blockName ?? '';
      valueController.text =
          configBlockModel?.configArguments['value'].toString() ?? '';
    }

    nameFocusNode.requestFocus();

    if (isValidForm()) {
      enableAddModifyNotifier.value = true;
    }
    return AlertDialog(
      title: Text('$actionLabel  ${canvasDialog ? 'value' : 'variable'}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!canvasDialog)
            ValueListenableBuilder<String?>(
              valueListenable: nameErrorNotifier,
              builder: (context, nameError, _) {
                return TextField(
                  focusNode: nameFocusNode,
                  onSubmitted: (_) {
                    valueFocusNode.requestFocus();
                  },
                  decoration: const InputDecoration(
                    label: Text(
                      'Name',
                    ),
                  ),
                  controller: nameController,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      nameErrorNotifier.value = 'Empty value not allowed';
                    } else {
                      nameErrorNotifier.value = null;
                    }
                    enableAddModifyNotifier.value = isValidForm();
                  },
                );
              },
            ),
          ValueListenableBuilder<String?>(
              valueListenable: valueErrorNotifier,
              builder: (context, valueError, _) {
                return TextField(
                  focusNode: valueFocusNode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: const Text(
                      'Value',
                    ),
                    errorText: valueError,
                  ),
                  controller: valueController,
                  onSubmitted: (_) {
                    onAction(context);
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      valueErrorNotifier.value = 'Empty value not allowed';
                    } else {
                      valueErrorNotifier.value = validator(value);
                    }
                    enableAddModifyNotifier.value = isValidForm();
                  },
                );
              }),
        ],
      ),
      actions: [
        if (enableRemove)
          TextButton(
            onPressed: () {
              removeCallback(context);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Remove',
            ),
          ),
        ValueListenableBuilder<bool>(
            valueListenable: enableAddModifyNotifier,
            builder: (context, enable, _) {
              return TextButton(
                child: Text(actionLabel),
                onPressed: enable
                    ? () {
                        onAction(context);
                      }
                    : null,
              );
            }),
      ],
    );
  }

  Future<T?> show(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (_) => this,
    );
    if (!completer.isCompleted) {
      completer.complete(null);
    }
    return completer.future;
  }
}
