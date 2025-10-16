import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool hasScanned = false;
  static const Color mainGreen = Color.fromARGB(255, 131, 176, 125);

  Future<void> _handleQrScan(String code) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> usedQrs = prefs.getStringList('used_qr_codes') ?? [];

    if (usedQrs.contains(code)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ QR นี้ถูกใช้ไปแล้ว!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    int currentCoin = prefs.getInt('ttcoin') ?? 0;
    await prefs.setInt('ttcoin', currentCoin + 1);

    usedQrs.add(code);
    await prefs.setStringList('used_qr_codes', usedQrs);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🎉 ได้รับแต้ม +1 (รวมทั้งหมด: ${currentCoin + 1})"),
        backgroundColor: mainGreen,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("สแกน QR เพื่อรับแต้ม"),
        backgroundColor: mainGreen,
      ),
      body: Stack(
        children: [
          // ✅ ตัวสแกนหลัก
          MobileScanner(
            onDetect: (BarcodeCapture capture) {
              if (hasScanned) return;
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;
                if (code != null && code.isNotEmpty) {
                  setState(() => hasScanned = true);
                  _handleQrScan(code);
                }
              }
            },
          ),

          // ✅ แสดง loading ตอนกำลังประมวลผล
          if (hasScanned)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
