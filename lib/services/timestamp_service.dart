import 'package:timezone/timezone.dart' as tz;

class TimestampService {
  static DateTime fromTimestamp(String input) {
    final value = int.parse(input.trim());

    final milliseconds =
        input.trim().length == 10 ? value * 1000 : value;

    return DateTime.fromMillisecondsSinceEpoch(
      milliseconds,
      isUtc: true,
    );
  }

  static tz.TZDateTime convertToTimezone(
    DateTime utcDateTime,
    String timezone,
  ) {
    return tz.TZDateTime.from(
      utcDateTime,
      tz.getLocation(timezone),
    );
  }
}