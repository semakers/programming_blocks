import 'package:programming_blocks/programming_blocks.dart';
import 'package:flutter/material.dart';

class ModifyStringDialog extends VariableDialog<ConfigurationBlockModel> {
  ModifyStringDialog({
    Key? key,
    required ConfigurationBlockModel? stringConfigBlockModel,
    required this.onRemove,
  }) : super(
          key: key,
          actionLabel: 'Modify',
          enableRemove: true,
          canvasDialog: false,
          validator: (value) {
            return null;
          },
          configBlockModel: stringConfigBlockModel,
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
