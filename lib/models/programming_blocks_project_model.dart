import 'dart:convert';

import 'package:programming_blocks/models/configuration_block_model.dart';
import 'package:programming_blocks/models/programming_blocks_canvas_model.dart';

ProgrammingBlocksProjectModel programmingBlocksProjectFromJson(String str) =>
    ProgrammingBlocksProjectModel.fromJson(json.decode(str));

class ProgrammingBlocksProjectModel {
  ProgrammingBlocksProjectModel({
    required this.functionsCanvas,
    required this.configurationModels,
  });

  final List<ProgrammingBlocksDependencyCanvasModel> functionsCanvas;
  final List<ConfigurationBlockModel> configurationModels;

  factory ProgrammingBlocksProjectModel.fromJson(Map<String, dynamic> json) {
    return ProgrammingBlocksProjectModel(
      functionsCanvas: List<ProgrammingBlocksDependencyCanvasModel>.from(
          json["functions_canvas"]
              .map((x) => ProgrammingBlocksDependencyCanvasModel.fromJson(x))),
      configurationModels: List<ConfigurationBlockModel>.from(
          json["configuration_models"]
              .map((x) => ConfigurationBlockModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        'functions_canvas': List.from(
          functionsCanvas.map(
            (e) => e.toJson(),
          ),
        ),
        'configuration_models': List.from(
          configurationModels.map(
            (e) => e.toJson(),
          ),
        ),
      };
}
