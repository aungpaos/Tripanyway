import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    // ป้องกันสแกนซ้ำ
    if (qr == "ANYWAY-1761228054540-FNGJGWMTG") {
      final alreadyScanned = prefs.getBool('scanned_TTCOIN_759') ?? false;
      if (alreadyScanned) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('QR นี้ถูกใช้ไปแล้ว')),
          );
        }
      } else {
        int coins = prefs.getInt('coins') ?? 0;
        await prefs.setInt('coins', coins + 759);
        await prefs.setBool('scanned_TTCOIN_759', true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('รับ TTcoin 759 coins สำเร็จ!')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR ไม่ถูกต้อง')),
        );
      }
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) Navigator.pop(context);
    });
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