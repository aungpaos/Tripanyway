import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'scan_qr_page.dart';

class TTcoinTab extends StatefulWidget {
  final String username;
  const TTcoinTab({super.key, required this.username});

  @override
  State<TTcoinTab> createState() => _TTcoinTabState();
}

class _TTcoinTabState extends State<TTcoinTab> {
  int coins = 0;
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    _loadCoins();
    _loadHistory();
  }

  Future<void> _loadCoins() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt('coins') ?? 0;
    });
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('ttcoin_history') ?? [];
    setState(() {
      history = raw.map((e) => Map<String, dynamic>.from(jsonDecode(e))).toList();
    });
  }

  Future<void> _scanQR() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => ScanQRPage(username: widget.username),
      ),
    );
    // ถ้ามีผลลัพธ์จากการสแกน ให้บันทึกลง history
    if (result != null) {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList('ttcoin_history') ?? [];
      raw.add(jsonEncode(result));
      await prefs.setStringList('ttcoin_history', raw);
      await _loadCoins();
      await _loadHistory();
    } else {
      await _loadCoins();
      await _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int baht = (coins / 75).floor(); // 75 coins = 1 baht
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7EFB2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF8DC26F), width: 2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TTcoin', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      Text('$coins coin ($baht บาท)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.only(left:8.0), child: Text('*โดย 75 TT coin = 1 บาท', style: TextStyle(color: Colors.redAccent)))),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), 
              borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(16),
              child: Column(children: const [
                Text('ภารกิจ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('TTcoin รับได้จากการสแกน TT Checkpoint'),
              ]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('สแกน QR รับ TTcoin'),
              onPressed: _scanQR,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 131, 176, 125),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 24),
            if (history.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ประวัติการรับ TTcoin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...history.reversed.map((item) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.qr_code),
                      title: Text(item['place'] ?? 'ไม่ระบุ'),
                      subtitle: Text(item['date'] ?? ''),
                      trailing: Text('+${item['amount']} coin', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ),
                  )),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
