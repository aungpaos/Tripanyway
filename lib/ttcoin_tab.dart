import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TTcoinTab extends StatefulWidget {
  final String username;
  const TTcoinTab({super.key, required this.username});

  @override
  State<TTcoinTab> createState() => _TTcoinTabState();
}

class _TTcoinTabState extends State<TTcoinTab> {
  int coins = 0;

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  Future<void> _loadCoins() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt('coins') ?? 0;
    });
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
                      Text('คุณมี $coins coin', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      Text('หรือ $baht บาท', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(16),
              child: Column(children: const [
                Text('ภารกิจ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('TTcoin รับได้จากการเข้าใกล้ TT Checkpoint'),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
