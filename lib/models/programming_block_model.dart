import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';

class ProgrammingBlockModel {
  ProgrammingBlockModel({
    List<ProgrammingBlockSelectorModel>? selectors,
    List<ProgrammingBlockModel>? blocks,
    this.configurationUuid = ProgrammingBlocksDependency.noConfigUUid,
    this.defaultData,
    List<ProgrammingBlockInputModel>? inputs,
    this.name = '',
    this.position = Offset.zero,
    required this.type,
    this.returnType,
    this.panelArguments = const {},
  })  : selectors = selectors ?? [],
        blocks = blocks ?? [],
        inputs = inputs ?? [];

  List<ProgrammingBlockSelectorModel> selectors;
  List<ProgrammingBlockModel> blocks;
  String configurationUuid;
  Map<String, dynamic>? defaultData;
  List<ProgrammingBlockInputModel> inputs;
  String name;
  Offset position;
  String type;
  String? returnType;
  Map<String, dynamic> panelArguments;

  Map<String, dynamic> toJson() => {
        'selectors': List.from(
          selectors.map(
            (e) => e.toJson(),
          ),
        ),
        'blocks': List.from(
          blocks.map(
            (e) => e.toJson(),
          ),
        ),
        'configuration_uuid': configurationUuid,
        'default_data': defaultData,
        'inputs': List.from(
          inputs.map(
            (e) => e.toJson(),
          ),
        ),
        'name': name,
        'position_x': position.dx,
        'position_y': position.dy,
        'type': type,
        'return_type': returnType,
        'panel_arguments': panelArguments,
      };

  factory ProgrammingBlockModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProgrammingBlockModel(
      selectors: List<ProgrammingBlockSelectorModel>.from(json["selectors"]
          .map((x) => ProgrammingBlockSelectorModel.fromJson(x))),
      blocks: List<ProgrammingBlockModel>.from(
          json["blocks"].map((x) => ProgrammingBlockModel.fromJson(x))),
      configurationUuid: json['configuration_uuid'],
      defaultData: json['default_data'],
      inputs: List<ProgrammingBlockInputModel>.from(
          json["inputs"].map((x) => ProgrammingBlockInputModel.fromJson(x))),
      name: json['name'],
      position:
          Offset(json['position_x'].toDouble(), json['position_y'].toDouble()),
      type: json['type'],
      returnType: json['return_type'],
      panelArguments: json['panel_arguments'],
    );
  }
}
