Map<String, String> flatten(Map<String, dynamic> orig, [String? parentKey]) {
  Map<String, String> result = {};
  orig.forEach(
    (key, value) {
      var newKey = parentKey != null ? '$parentKey.$key' : key;
      if (value is Map) {
        var flattened = flatten(value as Map<String, dynamic>, newKey);
        result.addAll(flattened);
      } else if (value is String) {
        result[newKey] = value;
      } else {
        throw Exception(
            'Value $value has an incompatible type ${value.runtimeType}. Only String and Map are allowed.');
      }
    },
  );
  return result;
}
