import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // Import the file where LoginPage is defined

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
          const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('ออกจากระบบ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (!mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
        ],
      ),
    );
  }
}
