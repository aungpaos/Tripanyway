import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool _saving = false;

  Future<void> _signUp() async {
    final u = userCtrl.text.trim();
    final p = passCtrl.text;
    if (u.isEmpty || p.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')));
      return;
    }
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', u);
    await prefs.setString('password', p);
    await prefs.setInt('coins', 0);
    await prefs.setBool('got_coin_from_esp', false); // ยังไม่ได้รับจาก ESP
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('สมัครเรียบร้อย')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // รูปด้านบนซ้าย + ข้อความตัวใหญ่
          Positioned(
            top: 72,
            left: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/anywaytrip.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(width: 16),
                const Text(
                  'เที่ยวทั่วทิศ\nAnywayTrip',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 125, 172, 191),
                    fontFamily: 'ITIM', // ใช้ฟอนต์เดียวกับหน้า Login
                  ),
                ),
              ],
            ),
          ),
          // ฟอร์มตรงกลาง
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: userCtrl, decoration: const InputDecoration(labelText: 'username')),
                  const SizedBox(height: 8),
                  TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'password')),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saving ? null : _signUp,
                    child: _saving ? const CircularProgressIndicator() : const Text('Sign Up'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 131, 176, 125),
                      foregroundColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
