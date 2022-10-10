class ProgrammingBlockSelectorModel {
  ProgrammingBlockSelectorModel({
    required this.data,
    required this.key,
  });
  String data;
  final String key;

  Map<String, dynamic> toJson() => {
        'data': data,
        'key': key,
      };

  factory ProgrammingBlockSelectorModel.fromJson(Map<String, dynamic> json) =>
      ProgrammingBlockSelectorModel(
        data: json['data'],
        key: json['key'],
      );
}
