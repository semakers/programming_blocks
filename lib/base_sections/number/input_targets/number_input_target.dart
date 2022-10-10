import 'package:programming_blocks/base_sections/number/dialogs/canvas_number_dialog.dart';
import 'package:programming_blocks/base_sections/number/number_puzzle_piece.dart';
import 'package:programming_blocks/base_sections/number/number_serializable.dart';
import 'package:flutter/material.dart';
import 'package:programming_blocks/ui/block_input/block_input_target.dart';
import 'package:programming_blocks/ui/block_input/block_input_target_controller.dart';

class NumberInputTarget extends BlockInputTarget {
  const NumberInputTarget({
    Key? key,
    required String blockInputTargetKey,
    Map<String, dynamic> defaultData = const {'value': 0},
  }) : super(
          key: key,
          blockInputTargetKey: blockInputTargetKey,
          acceptedType: 'NUMBER',
          defaultData: defaultData,
          puzzlePieceData: const NumberPuzzlePiece(),
        );

  @override
  Widget valueOverview(Map<String, dynamic>? value) {
    bool isReal = NumberSerializable.fromMap(value).remainder(1) == 0;

    return isReal
        ? Text('${NumberSerializable.fromMap(value).toInt()}')
        : Text('${NumberSerializable.fromMap(value)}');
  }

  @override
  Future<void> onValueOverviewTap(
      BuildContext context,
      Map<String, dynamic>? value,
      BlockInputTargetController controller) async {
    final _value = await CanvasNumberDialog(
      defaultValue: (NumberSerializable.fromMap(value)).toString(),
    ).show(context);
    if (_value != null) {
      controller.updateBlockInputValue(
        value: NumberSerializable.toMap(_value),
      );
    }
  }
}
