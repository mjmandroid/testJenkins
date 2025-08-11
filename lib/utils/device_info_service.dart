// import 'dart:io';

// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:battery_plus/battery_plus.dart';
// import 'package:wifi_scan/wifi_scan.dart';
// import 'package:permission_handler/permission_handler.dart';

// /// 设备信息服务类
// class DeviceInfoService {
//   final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;
//   final Battery _battery = Battery();
  
//   /// 获取蓝牙设备列表
//   Future<List<ScanResult>> getBluetoothDevices() async {
//     // 检查权限
//     if (!await _checkBluetoothPermissions()) {
//       throw Exception('没有蓝牙权限');
//     }
    
//     List<ScanResult> results = [];
    
//     // 监听扫描结果
//     _flutterBlue.scanResults.listen((scanResults) {
//       results = scanResults;
//     });
    
//     // 开始扫描
//     await _flutterBlue.startScan(timeout: const Duration(seconds: 4));
    
//     // 等待扫描完成
//     await Future.delayed(const Duration(seconds: 4));
    
//     // 停止扫描
//     await _flutterBlue.stopScan();
    
//     return results;
//   }

//   /// 获取电池电量
//   Future<int> getBatteryLevel() async {
//     return await _battery.batteryLevel;
//   }

//   /// 获取电池状态
//   Stream<BatteryState> getBatteryState() {
//     return _battery.onBatteryStateChanged;
//   }

//   /// 获取WiFi列表
//   Future<List<WiFiAccessPoint>> getWifiList() async {
//     // 检查权限
//     if (!await _checkWifiPermissions()) {
//       throw Exception('没有WiFi权限');
//     }

//     // 检查是否可以进行WiFi扫描
//     final can = await WiFiScan.instance.canStartScan();
//     if (can != CanStartScan.yes) {
//       throw Exception('无法进行WiFi扫描');
//     }

//     // 开始扫描
//     final result = await WiFiScan.instance.startScan();
//     if (!result) {
//       throw Exception('WiFi扫描失败');
//     }

//     // 获取扫描结果
//     final accessPoints = await WiFiScan.instance.getScannedResults();
//     return accessPoints;
//   }

//   /// 检查蓝牙权限
//   Future<bool> _checkBluetoothPermissions() async {
//     if (Platform.isAndroid) {
//       final bluetoothScan = await Permission.bluetoothScan.request();
//       final bluetoothConnect = await Permission.bluetoothConnect.request();
//       final location = await Permission.location.request();
      
//       return bluetoothScan.isGranted && 
//              bluetoothConnect.isGranted && 
//              location.isGranted;
//     }
    
//     if (Platform.isIOS) {
//       final bluetooth = await Permission.bluetooth.request();
//       return bluetooth.isGranted;
//     }
    
//     return false;
//   }

//   /// 检查WiFi权限
//   Future<bool> _checkWifiPermissions() async {
//     if (Platform.isAndroid) {
//       final location = await Permission.location.request();
//       final nearbyWifiDevices = await Permission.nearbyWifiDevices.request();
      
//       return location.isGranted && nearbyWifiDevices.isGranted;
//     }
    
//     if (Platform.isIOS) {
//       final locationWhenInUse = await Permission.locationWhenInUse.request();
//       return locationWhenInUse.isGranted;
//     }
    
//     return false;
//   }
// }