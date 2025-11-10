import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ScanQRPage extends StatefulWidget {
  final String username;
  const ScanQRPage({super.key, required this.username});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  bool scanned = false;

  Future<void> _handleScan(BuildContext context, String qr) async {
    if (scanned) return;
    scanned = true;

    final prefs = await SharedPreferences.getInstance();

    // รูปแบบ: ANY-(เลขTTcoin)-(Base64สถานที่)-(random)
    final regExp = RegExp(r'^ANYWAY-(\d+)-([A-Za-z0-9+/=]+)-([A-Za-z0-9]+)$');
    final match = regExp.firstMatch(qr);

    if (match != null) {
      final coinStr = match.group(1) ?? '0';
      int coinAmount = int.tryParse(coinStr) ?? 0;

      final placeBase64 = match.group(2) ?? '';
      String placeName = '';
      try {
        placeName = utf8.decode(base64Decode(placeBase64));
      } catch (_) {
        placeName = '[decode error]';
      }

      final alreadyScanned = prefs.getBool('scanned_$qr') ?? false;
      if (alreadyScanned) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('QR นี้ถูกใช้ไปแล้ว')),
          );
        }
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.pop(context);
        });
      } else {
        int coins = prefs.getInt('coins') ?? 0;
        await prefs.setInt('coins', coins + coinAmount);
        await prefs.setBool('scanned_$qr', true);

        // สร้างข้อมูลประวัติ
        final now = DateTime.now();
        final historyItem = {
          'date': '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}',
          'place': placeName,
          'amount': coinAmount,
        };

        if (mounted) {
          // เพิ่มแจ้งเตือน
          final notiList = prefs.getStringList('notifications') ?? [];
          notiList.add('คุณได้รับ TTcoin $coinAmount coins จาก $placeName');
          await prefs.setStringList('notifications', notiList);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('รับ TTcoin $coinAmount coins จาก $placeName สำเร็จ!')),
          );
        }
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.pop(context, historyItem);
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR ไม่ถูกต้อง')),
        );
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final qr = barcode.rawValue ?? '';
            if (qr.isNotEmpty) {
              _handleScan(context, qr);
              break;
            }
          }
        },
      ),
    );
  }
}