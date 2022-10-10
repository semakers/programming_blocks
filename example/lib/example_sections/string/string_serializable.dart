class StringSerializable {
  static Map<String, dynamic> toMap(String? value) {
    return {'value': value ?? ''};
  }

  static String fromMap(Map<String, dynamic>? map) {
    return map?['value'] ?? '';
  }
}
