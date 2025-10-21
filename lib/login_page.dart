import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';
import 'tab_menu_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    final savedU = prefs.getString('username');
    final savedP = prefs.getString('password');

    final u = userCtrl.text.trim();
    final p = passCtrl.text;
    if (u == savedU && p == savedP) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TabMenuPage(username: u, avatarUrl: prefs.getString('profileImageUrl') ?? '')));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง')));
    }
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
                    fontFamily: 'ITIM', // เพิ่มบรรทัดนี้
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  ElevatedButton(onPressed: _login, child: const Text('confirm')),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage()));
                    },
                    child: const Text('sign up'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
