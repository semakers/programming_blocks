import 'dart:ui';

import 'package:programming_blocks/function_section/function_block_type.dart';
import 'package:programming_blocks/programming_blocks.dart';

class FunctionBlockModel extends ProgrammingBlockModel {
  FunctionBlockModel({
    required String configurationUuid,
    required String name,
  }) : super(
          selectors: [],
          blocks: [],
          configurationUuid: configurationUuid,
          inputs: [],
          name: name,
          position: Offset.zero,
          type: FunctionBlockType.typeName,
        );
}
