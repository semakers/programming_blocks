import 'package:programming_blocks/models/programming_block_model.dart';

class ConfigurationBlockModel {
  ConfigurationBlockModel({
    required this.configArguments,
    required this.typeName,
    required this.uuid,
    required this.blockName,
    required this.blockModel,
  });

  Map<String, dynamic> configArguments;
  String typeName;
  String blockName;
  String uuid;
  ProgrammingBlockModel blockModel;

  ConfigurationBlockModel copyWith(
      {Map<String, dynamic>? configArguments, String? name}) {
    return ConfigurationBlockModel(
      configArguments: configArguments ?? this.configArguments,
      typeName: typeName,
      uuid: uuid,
      blockName: name ?? blockName,
      blockModel: blockModel,
    );
  }

  Map<String, dynamic> toJson() => {
        'config_arguments': configArguments,
        'type_name': typeName,
        'block_name': blockName,
        'uuid': uuid,
        'block': blockModel.toJson()
      };

  static ConfigurationBlockModel fromJson(Map<String, dynamic> json) =>
      ConfigurationBlockModel(
        configArguments: json['config_arguments'],
        typeName: json['type_name'],
        blockName: json['block_name'],
        uuid: json['uuid'],
        blockModel: ProgrammingBlockModel.fromJson(
          json['block'],
        ),
      );
}
