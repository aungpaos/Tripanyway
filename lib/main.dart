import 'package:flutter/material.dart';
import 'login_page.dart';
import 'tab_menu_page.dart';

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);
final notificationNotifier = ValueNotifier<bool>(true);

void main() {
  runApp(const AnywayTripApp());
}

final ThemeData customLightTheme = ThemeData.light().copyWith(
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Color.fromARGB(255, 255, 255, 255), // mainGreen
    unselectedItemColor: Color.fromARGB(255, 224, 224, 224),
    backgroundColor: Color.fromARGB(255, 131, 176, 125),
  ),
);

final ThemeData customDarkTheme = ThemeData.dark().copyWith(
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Color.fromARGB(255, 255, 255, 255),
    unselectedItemColor: Colors.grey,
    backgroundColor: Color(0xFF444851),
  ),
  scaffoldBackgroundColor: const Color(0xFF444851),
  cardColor: const Color(0xFF575C66),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF444851),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: ThemeData.dark().colorScheme.copyWith(
    primary: const Color(0xFF7DACBF),
    secondary: const Color(0xFF83B07D),
    surface: const Color(0xFF575C66),
    background: const Color(0xFF444851),
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
);

class AnywayTripApp extends StatelessWidget {
  const AnywayTripApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Anyway Trip Application',
          theme: customLightTheme,
          darkTheme: customDarkTheme,
          themeMode: mode,
          home: TabMenuPage(
            themeNotifier: themeNotifier,
            notificationNotifier: notificationNotifier,
            username: 'Guest', // Provide a default or actual username
            avatarUrl: '',     // Provide a default or actual avatar URL
          ),
        );
      },
    );
  }
}
