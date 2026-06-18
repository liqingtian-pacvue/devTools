import 'dart:convert';

class JsonService {
  static String format(String input) {
    final object = jsonDecode(input);
    return const JsonEncoder.withIndent('  ').convert(object);
  }

  static String minify(String input) {
    final object = jsonDecode(input);
    return jsonEncode(object);
  }
}