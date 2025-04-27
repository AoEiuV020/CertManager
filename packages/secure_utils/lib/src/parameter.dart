class Parameter {
  Parameter._();
  static String concatValues(Map<String, String> map) {
    final sortedKeys = map.keys.toList()..sort();
    return sortedKeys.map((key) => map[key]).join();
  }
}
