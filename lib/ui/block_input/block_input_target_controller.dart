import 'package:flutter/material.dart';
import 'package:programming_blocks/models/programming_block_input_model.dart';
import 'package:programming_blocks/models/programming_block_model.dart';

class BlockInputTargetController extends InheritedWidget {
  BlockInputTargetController({
    Key? key,
    required Widget child,
    required this.inputModel,
  })  : valueNotifier = ValueNotifier(inputModel.defaultData ?? {}),
        super(child: child, key: key);

  final ProgrammingBlockInputModel inputModel;
  final ValueNotifier<ProgrammingBlockModel?> programmingBlockNotifier =
      ValueNotifier(
    null,
  );

  final ValueNotifier<bool> showEmptyNotifier = ValueNotifier(
    true,
  );

  final ValueNotifier<Map<String, dynamic>> valueNotifier;

  static BlockInputTargetController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BlockInputTargetController>();
  }

  @override
  bool updateShouldNotify(BlockInputTargetController oldWidget) {
    return true;
  }

  void removeBlock() {
    inputModel.programmingBlock = null;
    programmingBlockNotifier.value = null;
    showEmptyNotifier.value = true;
  }

  void setBlock({
    required ProgrammingBlockModel newBlockModel,
  }) {
    inputModel.programmingBlock = newBlockModel;
    programmingBlockNotifier.value = newBlockModel;
    showEmptyNotifier.value = false;
  }

  void updateBlockInputValue({
    required Map<String, dynamic> value,
  }) {
    inputModel.defaultData = value;
    valueNotifier.value = value;
  }
}
