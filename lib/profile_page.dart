import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ข้อมูลผู้ใช้
  String firstName = 'สมชาย';
  String lastName = 'ใจดี';
  String email = 'somchai.j@example.com';
  String phone = '081-234-5678';
  String birthday = '1 มกราคม 1990';
  String bio = 'นักพัฒนาแอป Flutter ที่ชื่นชอบกาแฟ ☕';
  final String profileImageUrl = 'https://i.pravatar.cc/150?img=3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์ของฉัน'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    phone: phone,
                    birthday: birthday,
                    bio: bio,
                  ),
                ),
              );

              if (updatedData != null) {
                setState(() {
                  firstName = updatedData['firstName'];
                  lastName = updatedData['lastName'];
                  email = updatedData['email'];
                  phone = updatedData['phone'];
                  birthday = updatedData['birthday'];
                  bio = updatedData['bio'];
                });
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // รูปโปรไฟล์
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
            ),
            const SizedBox(height: 20),
            // ชื่อเต็ม
            Text(
              '$firstName $lastName',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(email, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            const SizedBox(height: 16),
            // ข้อมูลส่วนตัวเพิ่มเติม
            ProfileInfoRow(label: 'ชื่อ', value: firstName),
            ProfileInfoRow(label: 'นามสกุล', value: lastName),
            ProfileInfoRow(label: 'วันเกิด', value: birthday),
            ProfileInfoRow(label: 'เบอร์โทร', value: phone),
            const SizedBox(height: 16),
            Text(
              bio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            // ปุ่มออกจากระบบ
            ElevatedButton.icon(
              onPressed: () async {
                // Clear username from SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('username');
                // Navigate to LoginPage using named route
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('ออกจากระบบ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 131, 176, 125 ),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================
// หน้าแก้ไขโปรไฟล์
// ======================
class EditProfilePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String birthday;
  final String bio;

  const EditProfilePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.bio,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController birthdayController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    birthdayController = TextEditingController(text: widget.birthday);
    bioController = TextEditingController(text: widget.bio);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthdayController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("แก้ไขโปรไฟล์"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(controller: firstNameController, decoration: const InputDecoration(labelText: "ชื่อ")),
            TextField(controller: lastNameController, decoration: const InputDecoration(labelText: "นามสกุล")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "อีเมล")),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "เบอร์โทร")),
            TextField(controller: birthdayController, decoration: const InputDecoration(labelText: "วันเกิด")),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: "Bio"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "firstName": firstNameController.text,
                  "lastName": lastNameController.text,
                  "email": emailController.text,
                  "phone": phoneController.text,
                  "birthday": birthdayController.text,
                  "bio": bioController.text,
                });
              },
              child: const Text("บันทึกการแก้ไข"),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================
// Widget แสดงข้อมูลส่วนตัว
// ======================
class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
