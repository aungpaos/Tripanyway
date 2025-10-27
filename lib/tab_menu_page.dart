// lib/tab_menu_page.dart
import 'package:flutter/material.dart';
import 'home_feed.dart';
import 'ttcoin_tab.dart';
import 'promotion_feed.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class TabMenuPage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  final ValueNotifier<bool> notificationNotifier;
  final String username;
  final String avatarUrl;

  const TabMenuPage({
    super.key,
    required this.themeNotifier,
    required this.notificationNotifier,
    required this.username,
    required this.avatarUrl,
  });

  @override
  State<TabMenuPage> createState() => _TabMenuPageState();
}

class _TabMenuPageState extends State<TabMenuPage> {
  int _currentIndex = 0;

  // avatar local
  late String avatarUrl;


  @override
  void initState() {
    super.initState();
    avatarUrl = widget.avatarUrl;
  }

  @override
  void dispose() {
    // ไม่ควร dispose Notifier ที่สร้างจาก main.dart
    // super.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color mainGreen = Color.fromARGB(255, 131, 176, 125);

    // สร้าง pages โดยส่ง username ไปยัง TTcoinTab
    final pages = <Widget>[
      const HomeFeed(),
      TTcoinTab(username: widget.username), // ต้องมี constructor รับ username
      const PromoFeedPage(),
      ProfilePage(), // ถ้าต้องการส่ง username/ avatarUrl ให้เพิ่มใน constructor
    ];

    // safety index
    final safeIndex =
        (_currentIndex >= 0 && _currentIndex < pages.length) ? _currentIndex : 0;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: widget.themeNotifier,
      builder: (context, mode, _) {
        // ถ้าต้องการให้หน้าเปลี่ยนธีมจริง ๆ ในระดับ TabMenuPage,
        // คุณอาจต้องให้ MaterialApp หลักฟังค่า notifier ด้วย (แก้ใน main.dart)
        return Scaffold(
          appBar: AppBar(
            backgroundColor: mainGreen,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfilePage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage:
                      avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl.isEmpty ? const Icon(Icons.person) : null,
                ),
              ),
            ),
            title: const Text(''), // ไม่มีข้อความด้านบนตามที่ขอ
            actions: [
              // ปุ่มแจ้งเตือน
              ValueListenableBuilder<bool>(
                valueListenable: widget.notificationNotifier,
                builder: (context, enabled, _) {
                  return IconButton(
                    icon: Image.asset('assets/images/icon4.png', width: 24, height: 24),
                    onPressed: () {
                      if (enabled) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('คุณมีการแจ้งเตือนใหม่')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('การแจ้งเตือนถูกปิด')),
                        );
                      }
                    },
                  );
                },
              ),
              // ปุ่ม Settings
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingsPage(
                        themeNotifier: widget.themeNotifier,
                        notificationNotifier: widget.notificationNotifier,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          body: pages[safeIndex],

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: safeIndex,
            // ลบ selectedItemColor และ unselectedItemColor ออก
            onTap: (i) => setState(() => _currentIndex = i),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/icon1.png', width: 24, height: 24),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/coin.png', width: 24, height: 24),
                label: 'TTcoin',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/icon3.png', width: 24, height: 24),
                label: 'Promotion',
              ),
            ],
          ),
        );
      },
    );
  }
}
