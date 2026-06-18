import 'dart:convert';

class Base64Service {
  static String encode(String input) {
    return base64Encode(utf8.encode(input));
  }

  static String decode(String input) {
    return utf8.decode(base64Decode(input.trim()));
  }
}