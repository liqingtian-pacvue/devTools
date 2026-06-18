class TimestampService {
  static DateTime fromTimestamp(String input) {
    final text = input.trim();
    final value = int.parse(text);

    final milliseconds = text.length == 10 ? value * 1000 : value;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  static int toSeconds(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  static int toMilliseconds(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }
}