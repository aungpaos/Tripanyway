// lib/bluetooth_service.dart
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class BluetoothServiceHandler {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  BluetoothDevice? _connectedDevice;
  final List<BluetoothCharacteristic> _characteristics = [];

  // ฟังก์ชันสแกนหาอุปกรณ์ BLE
  Future<void> scanForDevices() async {
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
  }

  // ฟังก์ชันเชื่อมต่อกับอุปกรณ์
  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    _connectedDevice = device;
    await _discoverServices();
  }

  // ค้นหา Services/Characteristics
  Future<void> _discoverServices() async {
    if (_connectedDevice == null) return;
    List<BluetoothService> services = await _connectedDevice!.discoverServices();

    for (var service in services) {
      for (var characteristic in service.characteristics) {
        _characteristics.add(characteristic);
      }
    }
  }

  // ปิดการเชื่อมต่อ
  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      _connectedDevice = null;
    }
  }

  // ✅ ฟังก์ชันนี้คือที่ TabMenuPage เรียกใช้
  Future<void> connectAndRequestCoin(String username) async {
    try {
      print('เริ่มสแกนอุปกรณ์...');
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

      // ฟังผลการสแกน
      final scanSubscription = FlutterBluePlus.scanResults.listen((results) async {
        for (ScanResult r in results) {
          // สมมุติว่าเราจะเชื่อมต่อกับอุปกรณ์ชื่อ "TTcoinDevice"
          if (r.device.name == "TTcoinDevice") {
            print('เจออุปกรณ์ TTcoinDevice กำลังเชื่อมต่อ...');
            await FlutterBluePlus.stopScan();

            await connectToDevice(r.device);

            // จำลอง: เมื่อเชื่อมต่อแล้วให้ + coin ใน SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            int currentCoin = prefs.getInt('ttcoin') ?? 0;
            await prefs.setInt('ttcoin', currentCoin + 1);

            print('เพิ่ม TTcoin ให้ผู้ใช้ $username แล้ว');
            await disconnect();
            break;
          }
        }
      });

      // รอให้สแกนเสร็จ
      await Future.delayed(const Duration(seconds: 5));
      await FlutterBluePlus.stopScan();
      await scanSubscription.cancel();
    } catch (e) {
      print("เกิดข้อผิดพลาดในการเชื่อมต่อ: $e");
      rethrow;
    }
  }
}
