import 'dart:ui';

import 'package:programming_blocks/function_section/function_scope_block_model.dart';
import 'package:programming_blocks/models/programming_block_model.dart';

class ProgrammingBlocksDependencyCanvasModel {
  ProgrammingBlocksDependencyCanvasModel({
    required this.title,
    required this.programmingBlocks,
    required this.functionScopeBlockModel,
    required this.size,
    required this.functionUuid,
  });

  String functionUuid;
  String title;
  Size size;
  List<ProgrammingBlockModel> programmingBlocks;
  FunctionScopeBlockModel functionScopeBlockModel;

  Map<String, dynamic> toJson() => {
        'function_uuid': functionUuid,
        'title': title,
        'width': size.width,
        'height': size.height,
        'blocks': List.from(
          programmingBlocks.map(
            (e) => e.toJson(),
          ),
        ),
        'function_scope': functionScopeBlockModel.toJson(),
      };

  factory ProgrammingBlocksDependencyCanvasModel.fromJson(
          Map<String, dynamic> json) =>
      ProgrammingBlocksDependencyCanvasModel(
          functionUuid: json['function_uuid'],
          title: json['title'],
          size: Size(json['width'].toDouble(), json['height'].toDouble()),
          programmingBlocks: List<ProgrammingBlockModel>.from(
              json["blocks"].map((x) => ProgrammingBlockModel.fromJson(x))),
          functionScopeBlockModel:
              FunctionScopeBlockModel.fromJson(json['function_scope']));
}
