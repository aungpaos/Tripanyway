import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'login_page.dart'; // Import the file where LoginPage is defined

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String birthday = '';
  String bio = '';
  String profileImageUrl =
      'https://docs.flutter.dev/assets/images/flutter-logo-sharing.png';
  String address = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // โหลดข้อมูลจาก SharedPreferences
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? 'พัดชะญีดุย';
      lastName = prefs.getString('lastName') ?? 'เอฟซีนาซ่า';
      email = prefs.getString('email') ?? 'somchai.j@example.com';
      phone = prefs.getString('phone') ?? '081-234-5678';
      birthday = prefs.getString('birthday') ?? '1 มกราคม 1990';
      bio = prefs.getString('bio') ?? 'AnywayTrip';
      profileImageUrl = prefs.getString('profileImageUrl') ??
          'https://docs.flutter.dev/assets/images/flutter-logo-sharing.png';
      address = prefs.getString('address') ?? 'กรุงเทพมหานคร';
    });
  }

  // บันทึกข้อมูลลง SharedPreferences
  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('birthday', birthday);
    await prefs.setString('bio', bio);
    await prefs.setString('profileImageUrl', profileImageUrl);
    await prefs.setString('address', address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
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
                    profileImageUrl: profileImageUrl,
                    address: address,
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
                  profileImageUrl = updatedData['profileImageUrl'];
                  address = updatedData['address'];
                });
                await _saveProfileData(); // ✅ บันทึกข้อมูลหลังแก้ไข
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$firstName $lastName',
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    phone,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    birthday,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bio,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String birthday;
  final String bio;
  final String profileImageUrl;
  final String address;

  const EditProfilePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.bio,
    required this.profileImageUrl,
    required this.address,
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
  late TextEditingController profileImageUrlController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    birthdayController = TextEditingController(text: widget.birthday);
    bioController = TextEditingController(text: widget.bio);
    profileImageUrlController = TextEditingController(text: widget.profileImageUrl);
    addressController = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthdayController.dispose();
    bioController.dispose();
    profileImageUrlController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขโปรไฟล์'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'ชื่อ'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'นามสกุล'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'อีเมล'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'เบอร์โทร'),
            ),
            TextField(
              controller: birthdayController,
              decoration: const InputDecoration(labelText: 'วันเกิด'),
            ),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
            TextField(
              controller: profileImageUrlController,
              decoration: const InputDecoration(labelText: 'Profile Image URL'),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'ที่อยู่'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'firstName': firstNameController.text,
                  'lastName': lastNameController.text,
                  'email': emailController.text,
                  'phone': phoneController.text,
                  'birthday': birthdayController.text,
                  'bio': bioController.text,
                  'profileImageUrl': profileImageUrlController.text,
                  'address': addressController.text,
                });
              },
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}