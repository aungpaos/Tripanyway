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
    if (qr == "TTCOIN_QR") {
      final prefs = await SharedPreferences.getInstance();
      int coins = prefs.getInt('coins') ?? 0;
      await prefs.setInt('coins', coins + 1);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('รับ TTcoin สำเร็จ!')),
        );
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