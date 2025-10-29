import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _otpSent = false;
  bool _verified = false;
  String _generatedOtp = '';

  void _sendOtp() {
    setState(() {
      _generatedOtp = '123456'; // 🔹 จำลอง OTP จริง ๆ ควรส่งจาก backend
      _otpSent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ส่ง OTP ไปที่ ${_phoneController.text} แล้ว')),
    );
  }

  void _verifyOtp() {
    if (_otpController.text.trim() == _generatedOtp) {
      setState(() {
        _verified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ยืนยัน OTP สำเร็จ')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP ไม่ถูกต้อง')),
      );
    }
  }

  Future<void> _saveNewPassword() async {
    if (_newPasswordController.text.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', _newPasswordController.text);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ตั้งรหัสผ่านใหม่สำเร็จ!')),
    );

    Navigator.pop(context); // 🔹 กลับไปหน้า LoginPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F0),
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: const Color.fromARGB(255, 131, 176, 125),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_otpSent && !_verified) ...[
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "เบอร์โทรศัพท์",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("ส่ง OTP"),
                ),
              ] else if (_otpSent && !_verified) ...[
                TextField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    labelText: "กรอก OTP",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("ยืนยัน OTP"),
                ),
              ] else if (_verified) ...[
                TextField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: "รหัสผ่านใหม่",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveNewPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("บันทึกรหัสผ่านใหม่"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}