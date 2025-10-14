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
      // custom UI like before...
      appBar: AppBar(title: const Text('Anyway Trip')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: userCtrl, decoration: const InputDecoration(labelText: 'username')),
          const SizedBox(height: 8),
          TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'password')),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
            }, child: const Text('Forgot Password?')),
          ),
          ElevatedButton(onPressed: _login, child: const Text('confirm')),
          TextButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage()));
          }, child: const Text('sign up')),
        ]),
      ),
    );
  }
}
