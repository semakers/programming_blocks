import 'package:flutter/material.dart';

import 'package:programming_blocks/ui/variable_dialog/variable_dialog.dart';

class CanvasStringDialog extends VariableDialog {
  CanvasStringDialog({
    Key? key,
    required String defaultValue,
  }) : super(
            key: key,
            canvasDialog: true,
            defaultValue: defaultValue,
            actionLabel: 'Modify',
            validator: (value) {
              return null;
            });

  @override
  void onAction(BuildContext context) {
    completer.complete(valueController.text);
    Navigator.of(context).pop();
  }
}
