import 'package:example/example_sections/string/dialogs/canvas_string_dialog.dart';
import 'package:example/example_sections/string/string_puzzle_piece.dart';
import 'package:example/example_sections/string/string_serializable.dart';

import 'package:flutter/material.dart';
import 'package:programming_blocks/ui/block_input/block_input_target.dart';
import 'package:programming_blocks/ui/block_input/block_input_target_controller.dart';

class StringInputTarget extends BlockInputTarget {
  const StringInputTarget({
    Key? key,
    required String blockInputTargetKey,
    Map<String, dynamic> defaultData = const {'value': ''},
  }) : super(
          key: key,
          blockInputTargetKey: blockInputTargetKey,
          acceptedType: 'STRING',
          defaultData: defaultData,
          puzzlePieceData: const StringPuzzlePiece(),
        );

  @override
  Widget valueOverview(Map<String, dynamic>? value) {
    if (value == null) {
      return const Text(' ');
    } else {
      return Text(value['value'].isEmpty ? '  ' : value['value']);
    }
  }

  @override
  Future<void> onValueOverviewTap(
      BuildContext context,
      Map<String, dynamic>? value,
      BlockInputTargetController controller) async {
    final _value = await CanvasStringDialog(
      defaultValue: (StringSerializable.fromMap(value)).toString(),
    ).show(context);
    if (_value != null) {
      controller.updateBlockInputValue(
        value: StringSerializable.toMap(_value),
      );
    }
  }
}
