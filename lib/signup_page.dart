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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากรอกข้อมูล')));
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
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: userCtrl, decoration: const InputDecoration(labelText: 'username')),
            const SizedBox(height: 8),
            TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'password')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saving ? null : _signUp,
              child: _saving ? const CircularProgressIndicator() : const Text('Sign Up'),
            )
          ],
        ),
      ),
    );
  }
}
