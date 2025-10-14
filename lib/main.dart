import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'tab_menu_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const AnywayTripApp());
}

class AnywayTripApp extends StatefulWidget {
  const AnywayTripApp({super.key});
  @override
  State<AnywayTripApp> createState() => _AnywayTripAppState();
}

class _AnywayTripAppState extends State<AnywayTripApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    setState(() => _themeMode = isDark ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    const mainGreen = Color.fromARGB(255, 131, 176, 125);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Anyway Trip Application',
      themeMode: _themeMode,
      theme: ThemeData(
        primaryColor: mainGreen,
        colorScheme: ColorScheme.fromSeed(seedColor: mainGreen),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: const StartupPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        // other routes...
      },
    );
  }
}

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});
  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_username == null) {
      return const LoginPage();
    } else {
      return TabMenuPage(username: _username!, avatarUrl: prefsAvatarUrl());
    }
  }

  // helper placeholder
  String prefsAvatarUrl() => '';
}
