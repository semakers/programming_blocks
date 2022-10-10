class NumberSerializable {
  static Map<String, dynamic> toMap(double? value) {
    return {'value': value ?? 0};
  }

  static double fromMap(Map<String, dynamic>? map) {
    return (map?['value'] ?? 0).toDouble();
  }
}
