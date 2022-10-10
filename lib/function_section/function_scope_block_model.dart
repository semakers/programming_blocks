import 'dart:ui';

import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';

class FunctionScopeBlockModel extends ProgrammingBlockModel {
  static const String typeName = 'FUNCTION';
  FunctionScopeBlockModel(
      {required List<ProgrammingBlockModel> blocks, String? configurationUuid})
      : super(
          selectors: [],
          blocks: blocks,
          configurationUuid:
              configurationUuid ?? ProgrammingBlocksDependency.noConfigUUid,
          inputs: [],
          position: Offset.zero,
          type: typeName,
          returnType: '',
        );

  @override
  factory FunctionScopeBlockModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FunctionScopeBlockModel(
      blocks: List<ProgrammingBlockModel>.from(
          json['blocks'].map((x) => ProgrammingBlockModel.fromJson(x))),
      configurationUuid: json['configuration_uuid'],
    );
  }
}
