import 'package:programming_blocks/models/programming_block_model.dart';

class ProgrammingBlockInputModel {
  ProgrammingBlockInputModel({
    required this.defaultData,
    required this.key,
    required this.programmingBlock,
  });

  Map<String, dynamic>? defaultData;
  final String key;
  ProgrammingBlockModel? programmingBlock;

  Map<String, dynamic> toJson() => {
        'default_data': defaultData,
        'key': key,
        'block': programmingBlock,
      };

  factory ProgrammingBlockInputModel.fromJson(Map<String, dynamic> json) =>
      ProgrammingBlockInputModel(
        defaultData: json['default_data'],
        key: json['key'],
        programmingBlock: json['block'] == null
            ? null
            : ProgrammingBlockModel.fromJson(
                json['block'],
              ),
      );
}
