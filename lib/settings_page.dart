import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  final ValueNotifier<bool> notificationNotifier;

  const SettingsPage({
    super.key,
    required this.themeNotifier,
    required this.notificationNotifier,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isDarkMode;
  late bool isNotificationEnabled;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.themeNotifier.value == ThemeMode.dark;
    isNotificationEnabled = widget.notificationNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("การตั้งค่า")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: isDarkMode,
            onChanged: (val) {
              setState(() => isDarkMode = val);
              widget.themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
            },
            secondary: const Icon(Icons.brightness_6),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text("การแจ้งเตือน"),
            value: isNotificationEnabled,
            onChanged: (val) {
              setState(() => isNotificationEnabled = val);
              widget.notificationNotifier.value = val;
            },
            secondary: const Icon(Icons.notifications),
          ),
        ],
      ),
    );
  }
}
