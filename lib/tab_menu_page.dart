// lib/tab_menu_page.dart
import 'package:flutter/material.dart';
import 'home_feed.dart';
import 'ttcoin_tab.dart';
import 'promotion_feed.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'bluetooth_service.dart'; // ถ้าใช้ปุ่มสแกน BLE (ไม่จำเป็นถ้าไม่มีไฟล์นี้)

class TabMenuPage extends StatefulWidget {
  final String username;
  final String avatarUrl;

  const TabMenuPage({
    super.key,
    required this.username,
    required this.avatarUrl,
  });

  @override
  State<TabMenuPage> createState() => _TabMenuPageState();
}

class _TabMenuPageState extends State<TabMenuPage> {
  int _currentIndex = 0;

  // Notifier ที่ตรงกับ SettingsPage (ตามไฟล์ settings_page.dart ของคุณ)
  final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.light);
  final ValueNotifier<bool> notificationNotifier = ValueNotifier<bool>(true);

  // avatar local
  late String avatarUrl;

  // (ถ้าคุณมี BluetoothService ให้ uncomment และใช้งาน)
final BluetoothServiceHandler _bluetoothService = BluetoothServiceHandler();



  @override
  void initState() {
    super.initState();
    avatarUrl = widget.avatarUrl;
  }

  @override
  void dispose() {
    themeNotifier.dispose();
    notificationNotifier.dispose();
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
      const ProfilePage(),
    ];

    // safety index
    final safeIndex =
        (_currentIndex >= 0 && _currentIndex < pages.length) ? _currentIndex : 0;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
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
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
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
              // ปุ่มแจ้งเตือน (จะอ่านค่า notificationNotifier ได้)
              ValueListenableBuilder<bool>(
                valueListenable: notificationNotifier,
                builder: (context, enabled, _) {
                  return IconButton(
                    icon: const Icon(Icons.notifications),
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

              // ปุ่ม Settings — ส่งทั้ง 2 notifiers ตามที่ SettingsPage ต้องการ
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingsPage(
                        themeNotifier: themeNotifier,
                        notificationNotifier: notificationNotifier,
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
            selectedItemColor: mainGreen,
            unselectedItemColor: Colors.grey,
            onTap: (i) => setState(() => _currentIndex = i),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'TTcoin'),
              BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Promotion'),
              // Profile tab removed
            ],
          ),

          // ถ้าต้องการปุ่มสแกน BLE ให้แสดงปุ่มด้านล่าง (ไม่จำเป็นต้องมี)
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              try {
                await _bluetoothService.connectAndRequestCoin(widget.username);
                setState(() {});
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('เกิดข้อผิดพลาด BLE: $e')),
                );
              }
            },
            icon: const Icon(Icons.bluetooth_searching),
            label: const Text('Scan & Get TTcoin'),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}