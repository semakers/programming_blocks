import 'package:programming_blocks/programming_blocks.dart';
import 'package:flutter/material.dart';

class ModifyNumberDialog extends VariableDialog<ConfigurationBlockModel> {
  ModifyNumberDialog({
    Key? key,
    required ConfigurationBlockModel? numberConfigBlockModel,
    required this.onRemove,
  }) : super(
          key: key,
          actionLabel: 'Modify',
          enableRemove: true,
          canvasDialog: false,
          validator: (value) {
            if (double.tryParse(value) == null) {
              return 'Only numbers allowed';
            }
            return null;
          },
          configBlockModel: numberConfigBlockModel,
        );

  final VoidCallback onRemove;

  @override
  void removeCallback(context) {
    onRemove();
  }

  @override
  void onAction(BuildContext context) {
    configBlockModel?.configArguments = {
      'value': valueController.text,
    };
    configBlockModel?.blockName = nameController.text;
    completer.complete(configBlockModel);
    Navigator.of(context).pop();
  }
}
