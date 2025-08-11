import 'dart:async';
import 'dart:convert';

import 'package:desk_cloud/content/tabs/tab_io_logic.dart';
import 'package:desk_cloud/content/tabs/tab_member_logic.dart';
import 'package:desk_cloud/entity/socket_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketLogic extends BaseLogic{
  
  var socketEntity = Rxn<SocketEntity>();
  IO.Socket? socket;
  Timer? _loginRetryTimer;
  final _maxRetryAttempts = 10; // 最大重试次数
  var _retryCount = 0;
  var socketLoginData = '';
  /// 任务数量
  int socketTaskCount = 0;

  Future<bool> initSocket() async {
    try {
      socketTaskCount++;
      if (socket != null && socket!.connected) {
        return false;
      }
      var base = await ApiNet.request<SocketEntity>(Api.getSocketToken);
      socketEntity.value = base.data;
      String? socketUrl = socketEntity.value?.server;
      if (socketUrl == null || socketUrl.isEmpty) {
        showShortToast('WebSocket 地址为空');
        return false;
      }
      
      // 创建 Completer 用于等待登录结果
      final completer = Completer<bool>();
      
      socketLoginData = jsonEncode({
        'uid': SP.token,
        'token': socketEntity.value?.token
      });
      
      socket = IO.io(
        socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
      );
      
      // 添加超时处理
      Timer(const Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          stopLoginRetry();
          completer.complete(false);
        }
      });

      socket!.connect();
      socket!.onConnect((_) {
        socket!.emit('login', socketLoginData);
      });

      socket!.on('login', (data) {
        // 确保 completer 还没有完成
        if (completer.isCompleted) return;
        
        if (data == 'success') {
          debugPrint('登录成功');
          stopLoginRetry();
          _setupEventListeners();
          completer.complete(true);
        } else {
          if (_retryCount < _maxRetryAttempts) {
            _loginRetryTimer?.cancel();
            _loginRetryTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
              _retryCount++;
              retryLogin();
              if (_retryCount >= _maxRetryAttempts) {
                stopLoginRetry();
                memberLogic.myRefresh();
                if (!completer.isCompleted) {
                  completer.complete(false);
                }
              }
            });
          } else {
            if (!completer.isCompleted) {
              completer.complete(false);
            }
          }
        }
      });

      // 添加错误处理
      socket!.onError((error) {
        debugPrint('Socket连接错误: $error');
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });

      socket!.onDisconnect((_) {
        debugPrint('Socket断开连接');
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });

      return await completer.future;

    } catch (e) {
      showShortToast(e.toString());
      return false;
    }
  }

  /// 设置事件监听器
  void _setupEventListeners() {
    // 移除所有事件监听器
    _removeEventListeners();

    socket!.on('pay', (data) {
      if (data == 'success') {
        debugPrint('支付成功');
        memberLogic.myRefresh();
        closeSocket();
      }
    });

    socket!.on('unzip', (data) async {
      // 先解码 HTML 实体
      String decodedData = data.toString()
          .replaceAll('&quot;', '"')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>');
      Map<String, dynamic> dataMap = jsonDecode(decodedData);
      if (dataMap['status'] == 'success') {
        String taskId = dataMap['task_id'].toString();
        int relationDirId = dataMap['relation_dir_id'];
        String title = dataMap['title'].toString();
        debugPrint('解压任务id：$taskId');
        ioLogic.socketOnUnzip(taskId, relationDirId, title);
        socketTaskCount--;
        if (socketTaskCount <= 0) {
          closeSocket();
        }
      }
    });

    socket!.on('logout', (data) {
      if (data == 'success' && socket != null && socket!.connected) {
        socketTaskCount = 0;
        debugPrint('退出登录');
        socket!.disconnect();
        socket = null;
      }
    });
  }

  /// 尝试重新登录
  void retryLogin() {
    socket!.emit('login', socketLoginData);
  }

  /// 停止重试登录
  void stopLoginRetry() {
    _loginRetryTimer?.cancel();
    _loginRetryTimer = null;
    _retryCount = 0;
  }

  /// 关闭socket
  void closeSocket() {
    if (socket != null && socket!.connected) {
      socket!.emit('logout');
    }
  }

  /// 移除所有事件监听器
  void _removeEventListeners() {
    if (socket != null) {
      socket!.off('pay');
      socket!.off('unzip');
      socket!.off('logout');
    }
  }

  /// 强制退出Socket
  void forceCloseSocket() {
    if (socket != null && socket!.connected) {
      socket!.emit('logout');
      socketTaskCount = 0;
      debugPrint('强制退出Socket');
      socket!.disconnect();
      socket = null;
    }
  }
}

SocketLogic get socketLogic {
  if (Get.isRegistered<SocketLogic>()){
    return Get.find<SocketLogic>();
  }
  return Get.put(SocketLogic());
}