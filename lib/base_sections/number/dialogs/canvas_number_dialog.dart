import 'package:programming_blocks/ui/variable_dialog/variable_dialog.dart';
import 'package:flutter/material.dart';

class CanvasNumberDialog extends VariableDialog<double> {
  CanvasNumberDialog({
    Key? key,
    required String defaultValue,
  }) : super(
            key: key,
            canvasDialog: true,
            defaultValue: defaultValue,
            actionLabel: 'Modify',
            validator: (value) {
              if (double.tryParse(value) == null) {
                return 'Only numbers allowed';
              }
              return null;
            });

  @override
  void onAction(BuildContext context) {
    completer.complete(double.parse(valueController.text));
    Navigator.of(context).pop();
  }
}
