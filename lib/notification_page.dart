import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notifications = prefs.getStringList('notifications') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('แจ้งเตือน')),
      body: notifications.isEmpty
          ? const Center(child: Text('ไม่มีแจ้งเตือน'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(notifications[notifications.length - 1 - index]),
              ),
            ),
    );
  }
}