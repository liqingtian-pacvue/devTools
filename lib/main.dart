import 'package:flutter/material.dart';

import 'core/theme_controller.dart';
import 'pages/base64_page.dart';
import 'pages/json_page.dart';
import 'pages/timestamp_page.dart';
import 'widgets/tool_search.dart';

final themeController = ThemeController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await themeController.load();

  runApp(const DevToolsApp());
}

class DevToolsApp extends StatelessWidget {
  const DevToolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'DevKit',
          debugShowCheckedModeBanner: false,
          themeMode: themeController.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            colorSchemeSeed: const Color(0xFF111827),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            colorSchemeSeed: const Color(0xFFCBD5E1),
          ),
          home: const HomePage(),
        );
      },
    );
  }
}

class ToolItem {
  const ToolItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.page,
  });

  final String title;
  final String description;
  final IconData icon;
  final Widget page;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final searchController = TextEditingController();
  String searchKeyword = '';

  final tools = const [
    ToolItem(
      title: 'JSON Formatter',
      description: 'Format, validate and minify JSON',
      icon: Icons.account_tree_outlined,
      page: JsonPage(),
    ),
    ToolItem(
      title: 'Timestamp Converter',
      description: 'Convert Unix timestamps to readable dates',
      icon: Icons.schedule_outlined,
      page: TimestampPage(),
    ),
    ToolItem(
      title: 'Base64 Encoder',
      description: 'Encode and decode Base64 strings',
      icon: Icons.code_outlined,
      page: Base64Page(),
    ),
  ];

  List<ToolItem> get filteredTools {
    final keyword = searchKeyword.trim().toLowerCase();

    if (keyword.isEmpty) return tools;

    return tools.where((tool) {
      return tool.title.toLowerCase().contains(keyword) ||
          tool.description.toLowerCase().contains(keyword);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void toggleTheme() {
    final current = themeController.themeMode;

    final next = current == ThemeMode.light
        ? ThemeMode.dark
        : current == ThemeMode.dark
            ? ThemeMode.system
            : ThemeMode.light;

    themeController.setThemeMode(next);
  }

  IconData get themeIcon {
    return themeController.themeMode == ThemeMode.dark
        ? Icons.dark_mode
        : themeController.themeMode == ThemeMode.light
            ? Icons.light_mode
            : Icons.brightness_auto;
  }

  @override
  Widget build(BuildContext context) {
    final selectedTool = tools[selectedIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sidebarColor = isDark ? const Color(0xFF111827) : Colors.white;
    final pageBgColor =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final mutedTextColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: pageBgColor,
      body: Row(
        children: [
          Container(
            width: 240,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: sidebarColor,
              border: Border(
                right: BorderSide(color: borderColor),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DevKit',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Developer Toolbox',
                  style: TextStyle(color: mutedTextColor),
                ),
                const SizedBox(height: 16),
                ToolSearch(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchKeyword = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                if (filteredTools.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'No tools found',
                      style: TextStyle(color: mutedTextColor),
                    ),
                  )
                else
                  for (final tool in filteredTools)
                    _SidebarItem(
                      title: tool.title,
                      icon: tool.icon,
                      selected: selectedTool.title == tool.title,
                      onTap: () {
                        setState(() {
                          selectedIndex = tools.indexOf(tool);
                        });
                      },
                    ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: pageBgColor,
                    border: Border(
                      bottom: BorderSide(color: borderColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedTool.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            selectedTool.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: mutedTextColor,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: '切换主题',
                        onPressed: toggleTheme,
                        icon: Icon(themeIcon),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: cardColor,
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: selectedTool.page,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected
                ? isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFF3F4F6)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}