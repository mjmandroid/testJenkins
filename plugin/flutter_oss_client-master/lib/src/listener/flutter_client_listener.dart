import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_client_oss/src/entity/task_progress.dart';
import 'package:flutter_client_oss/src/entity/task_result.dart';

class FlutterClientListener{

  final StreamController<TaskProgress> _taskProgressStreamController =
  StreamController<TaskProgress>.broadcast();

  final StreamController<TaskResult> _taskResultSteamController =
  StreamController<TaskResult>.broadcast();

  StreamController<TaskProgress> get taskProgressStreamController => _taskProgressStreamController;
  StreamController<TaskResult> get taskResultSteamController => _taskResultSteamController;

  Future<dynamic> handler(MethodCall call) async{
    print(call.arguments);
    print(call.method);
    switch(call.method){
      case 'uploadProgress':
        _taskProgressStreamController.add(TaskProgress.fromJson(Map.from(call.arguments))..upload = true);
        break;
      case 'downloadProgress':
        _taskProgressStreamController.add(TaskProgress.fromJson(Map.from(call.arguments))..upload = false);
        break;
      case 'uploadResult':
        _taskResultSteamController.add(TaskResult.fromJson(Map.from(call.arguments))..upload = true);
        break;
      case 'downloadResult':
        _taskResultSteamController.add(TaskResult.fromJson(Map.from(call.arguments))..upload = false);
        break;
    }
  }
}