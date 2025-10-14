import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// เปลี่ยนชื่อแพ็กเกจให้ตรงกับ pubspec.yaml
import 'package:anyway_trip_application/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // ถ้าใน main.dart ของคุณใช้ชื่อ class หลักว่า MyApp → แก้ตรงนี้
    await tester.pumpWidget(const AnywayTripApp());

    // ตรวจสอบว่าหน้าแรกโหลดขึ้นได้หรือไม่
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
