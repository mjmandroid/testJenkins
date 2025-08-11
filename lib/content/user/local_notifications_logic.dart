import 'dart:io';

import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


/// 使用通知的方式让程序保活：请注意，这种方式仅支持Android，IOS 暂不支持保活，并且如果用户不授权通知权限，会导致无法保活
/// 通知方式，0 下载，1 上传
class LocalNotificationsLogic extends BaseLogic {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  /// 是否初始化
  bool _isNotificationInitialized = false;

  @override
  void onInit() {
    super.onInit();
    if (Platform.isAndroid) {
      _initNotifications();
    }
  }

  /// 初始化通知
  Future<void> _initNotifications() async {
    if (_isNotificationInitialized) return;

    try {
      // 初始化 Android 设置
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/icon_logo');
          
      // // 初始化 iOS 设置
      // const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      //   requestSoundPermission: false,
      //   requestBadgePermission: false,
      //   requestAlertPermission: true,
      // );

      // 组合设置
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        // iOS: initializationSettingsIOS,
      );

      // 初始化插件
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('通知点击：${response.payload}');
        },
      );

      // 创建通知渠道（仅 Android）
      if (Platform.isAndroid) {
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'download_channel',
          '文件传输通知',
          description: '用于显示文件传输进度',
          importance: Importance.low,
          playSound: false,
          enableVibration: false,
        );

        await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
      }

      _isNotificationInitialized = true;
      debugPrint('通知初始化成功');
    } catch (e) {
      debugPrint('通知初始化失败: $e');
    }
  }

  /// 显示下载通知
  Future<dynamic> showDownloadNotification() async {
    /// 非安卓平台不支持通知
    if (!Platform.isAndroid) {
      return true;
    }

    var hasPermission = await requestNotificationPermission();
    if (hasPermission == null) {
      return null;
    } else if (!hasPermission) {
      return false;
    }

    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'download_channel',
        '文件传输通知',
        channelDescription: '用于显示文件传输进度',
        importance: Importance.low,
        priority: Priority.low,
        playSound: false,
        enableVibration: false,
        ongoing: true,
        autoCancel: false,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentSound: false,
        presentBadge: false,
        threadIdentifier: 'download_thread',
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        '文件下载中',
        '正在后台下载文件...',
        details,
        payload: 'download',
      );
      debugPrint('通知已发送');
      return true;
    } catch (e) {
      debugPrint('显示通知失败: $e');
      return false;
    }
  }

  /// 显示上传通知
  Future<dynamic> showUploadNotification() async {
    /// 非安卓平台不支持通知
    if (!Platform.isAndroid) {
      return true;
    }

    var hasPermission = await requestNotificationPermission();
    if (hasPermission == null) {
      return null;
    } else if (!hasPermission) {
      return false;
    }

    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'download_channel',
        '文件传输通知',
        channelDescription: '用于显示文件传输进度',
        importance: Importance.low,
        priority: Priority.low,
        playSound: false,
        enableVibration: false,
        ongoing: true,
        autoCancel: false,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentSound: false,
        presentBadge: false,
        threadIdentifier: 'upload_thread',
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        1, // 使用不同的通知ID，避免与下载通知冲突
        '文件上传中',
        '正在后台上传文件...',
        details,
        payload: 'upload',
      );
      debugPrint('上传通知已发送');
      return true;
    } catch (e) {
      debugPrint('显示上传通知失败: $e');
      return false;
    }
  }

  /// 取消下载通知
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

}

LocalNotificationsLogic get localNotificationsLogic {
  if (Get.isRegistered<LocalNotificationsLogic>()){
    return Get.find<LocalNotificationsLogic>();
  }
  return Get.put(LocalNotificationsLogic());
}