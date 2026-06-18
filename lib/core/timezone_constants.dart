import '../widgets/tool_select.dart';

class TimezoneConstants {
  static const options = <ToolSelectOption>[
    ToolSelectOption(
      value: 'UTC',
      label: 'UTC',
    ),

    // Asia
    ToolSelectOption(
      value: 'Asia/Shanghai',
      label: '🇨🇳 Asia/Shanghai',
    ),
    ToolSelectOption(
      value: 'Asia/Tokyo',
      label: '🇯🇵 Asia/Tokyo',
    ),
    ToolSelectOption(
      value: 'Asia/Singapore',
      label: '🇸🇬 Asia/Singapore',
    ),
    ToolSelectOption(
      value: 'Asia/Seoul',
      label: '🇰🇷 Asia/Seoul',
    ),

    // America
    ToolSelectOption(
      value: 'America/Los_Angeles',
      label: '🇺🇸 Los Angeles',
    ),
    ToolSelectOption(
      value: 'America/New_York',
      label: '🇺🇸 New York',
    ),

    // Europe
    ToolSelectOption(
      value: 'Europe/London',
      label: '🇬🇧 London',
    ),
    ToolSelectOption(
      value: 'Europe/Paris',
      label: '🇫🇷 Paris',
    ),
  ];
}